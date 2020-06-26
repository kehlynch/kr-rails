class Game < ApplicationRecord
  belongs_to :match

  has_many :game_players, -> { order(:position) }
  has_many :players, through: :game_players
  has_many :cards, dependent: :destroy
  has_many :announcements, dependent: :destroy
  has_many :bids, dependent: :destroy

  has_many :tricks, dependent: :destroy

  has_many :announcement_scores

  scope :with_associations, -> {
    includes(
      :cards, 
      tricks: [:won_player, cards: :game_player],
      bids: :game_player,
      announcements: :game_player,
      game_players: [:won_tricks, :bids, :announcements]
    )
  }

  scope :for_scores, -> {
    includes(
      :announcement_scores,
      :bids,
      game_players: [won_tricks: :cards],
    )
  }

  def self.deal_game(match_id, _players)
    game = Game.create(match_id: match_id)
    create_players_for(game)
    (0..11).each do |index|
      Trick.create(game_id: game.id, trick_index: index)
    end

    Dealer.deal(game)
    return game
  end

  def self.create_players_for(game)
    game.match.match_players.map do |mp|
      forehand = mp.position == forehand_position_for(game)
      game.game_players.create(player: mp.player, position: mp.position, forehand: forehand, human: mp.human, name: mp.name)
    end
  end

  def self.forehand_position_for(game)
    game.match.earlier_games(game.id).count % 4
  end

  def reset!
    bids.destroy_all
    announcements.destroy_all
    game_players.update_all(declarer: false, partner: false, team: nil)
    cards.update_all(discard: false, trick_id: nil, played_index: nil)
    cards.where.not(talon_half: nil).update_all(game_player_id: nil)
    tricks.update_all(game_player_id: nil, finished: false)
    update(king: nil, talon_picked: nil, talon_resolved: false)
    Runner.new(self).advance!
  end

  def forehand
    game_players.find(&:forehand)
  end

  def declarer
    game_players.find(&:declarer)
  end

  def partner
    game_players.find(&:partner)
  end

  def declarers
    game_players.select { |gp| gp.team == GamePlayer::DECLARERS }
  end

  def defenders
    game_players.select { |gp| gp.team == GamePlayer::DEFENDERS }
  end

  def team_for(game_player)
    case game_player.team
    when GamePlayer::DEFENDERS
      defenders
    when GamePlayer::DECLARERS
      declarers
    else
      [game_player]
    end
  end

  def kings
    ['club_8', 'diamond_8', 'heart_8', 'spade_8'].map do |king_slug|
      # don't hit the db here
      cards.find { |c| c.slug == king_slug }
    end
  end

  def won_bid
    bids.find(&:won)
  end

  def talon_service
    TalonService.new(self)
  end

  def talon_halves
    talon_service.talon
  end

  def talon_cards
    cards.select { |c| c.talon_half.present? }
  end

  def talon_cards_to_pick
    return nil if won_bid.nil? || !won_bid.talon?

    return 6 if won_bid.slug == Bid::SECHSERDREIER

    return 3
  end

  def bird_required?
    won_bid&.slug == Bid::BESSER_RUFER
  end

  def stages_for(game_player)
    if game_player == declarer
      stages
    elsif declarer.nil?
      stages
    else
      stages.reject { |s| s == Stage::RESOLVE_TALON }
    end
  end

  def stages
    [
      [Stage::BID, true],
      [Stage::KING, won_bid&.king?],
      [Stage::PICK_TALON, talon_cards_to_pick.present?],
      [Stage::RESOLVE_TALON, talon_cards_to_pick.present?],
      [Stage::ANNOUNCEMENT, winning_bid&.announcements?],
      [Stage::TRICK, true],
      [Stage::FINISHED, true]
    ].select { |_s, valid| valid }.map(&:first)
  end

  def stage
    stages.find do |stage|
      !Stage.finished?(self, stage)
    end || Stage::FINISHED
  end

  def valid_announcements
    ValidAnnouncementsService.new(self).valid_announcements
  end

  def valid_bids
    ValidBidsService.new(self).valid_bids
  end

  def make_bid!(bid_slug = nil)
    return nil if (next_player_human? && !bid_slug) || won_bid.present?

    bid_slug ||= next_player.pick_bid(valid_bids)
    return unless valid_bids.include?(bid_slug)

    bid = bids.create(slug: bid_slug, game_player: next_player)

    if bid_second_round_finished?(winning_bid)
      winning_bid.update(won: true)
      winning_bid.game_player.update(declarer: true, team: GamePlayer::DECLARERS)
      game_players.reload

      if !winning_bid.king?
        set_defenders
      end
    end

    return bid
  end

  def make_announcement!(slug = nil)
    return nil if (next_player_human? && !slug) || announcements_finished?

    slug ||= next_player.pick_announcement(valid_announcements)
    return unless valid_announcements.include?(slug)

    announcement = announcements.create(slug: slug, game_player: next_player)

    return announcement
  end

  def pick_king!(king_slug)
    return if declarer&.human? && !king_slug

    self.king = king_slug || declarer.pick_king
    save

    partner = cards.find { |c| c.slug == king }.game_player
    partner&.update(partner: true, team: GamePlayer::DECLARERS)
    set_defenders
  end

  def pick_talon!(talon_half_index=nil)
    if talon_cards_to_pick == 6
      pick_whole_talon!
    else
      puts 'pick_talon!', declarer_human?, talon_half_index
      return if declarer_human? && talon_half_index.nil?

      talon_half_index = talon_service.pick_talon!(talon_half_index, declarer)

      update(talon_picked: talon_half_index)
    end
  end

  def pick_whole_talon!
    talon_service.pick_whole_talon!(declarer)

    # TODO: using 3 to mean all 6, since this is an int field and used to refer to the talon_half_index - sort this out!
    update(talon_picked: 3)
  end

  def resolve_talon!(putdown_card_slugs)
    return if declarer_human? && putdown_card_slugs.blank?

    talon_service.resolve_talon!(putdown_card_slugs, declarer)

    update(talon_resolved: true)
  end

  def play_card!(card=nil)
    return nil if (next_player_human? && !card) || finished?

    card ||= CardPicker.new(self, next_player).pick
    card = current_trick.add_card!(card)

    if finished?
      game_players.reload
      PointsService.new(self).record_points
    end

    return card
  end

  # TODO: this looks like it should go up a level
  def pick_card_for!(trick, bid, king)
  end


  def next_player_human?
    next_player&.human?
  end

  def declarer_human?
    declarer&.human?
  end

  def next_player_forehand?
    next_player&.forehand?
  end

  def next_player
    case stage
    when Stage::BID
      if bid_first_round_finished?
        forehand
      else
        next_player_by_position(bids.sort_by(&:id).last&.game_player) || forehand
      end
    when Stage::ANNOUNCEMENT
      next_player_by_position(last_passed_announcer) || declarer
    when Stage::KING, Stage::PICK_TALON, Stage::RESOLVE_TALON
      declarer
    when Stage::TRICK
      next_player_by_position(current_trick.last_player) ||
        last_finished_trick&.won_player ||
        bid_lead
    when Stage::FINISHED
      nil
    end
  end

  def current_trick
    last_played_trick =
      tricks
      .sort_by(&:trick_index)
      .reverse
      .find { |t| t.cards.any? }


    return tricks.find { |t| t.trick_index == 0 } unless last_played_trick

    return tricks.find { |t| t.trick_index == last_played_trick.trick_index + 1 } if last_played_trick.finished?

    return last_played_trick
  end

  def playable_trick_index
    current_trick&.trick_index
  end

  def winning_bid
    bids.max_by do |b|
      [b.rank, b.game_player.forehand? ? 1 : 0]
    end
  end

  def finished?
    tricks_finished?
  end


  def announcements_finished?
    return false unless announcements.map(&:game_player_id).uniq.count == 4

    announcements.sort_by(&:id).last(3).map(&:slug) == [Announcement::PASS] * 3
  end

  def bid_first_round_finished?
    bid_passed_player_count >= 3
  end

  def tricks_finished?
    tricks.find { |t| t.trick_index == 11 }.finished
  end

  private

  def bid_second_round_finished?(winning_bid)
    bid_first_round_finished? && (winning_bid.slug != Bid::RUFER)
  end

  def bid_passed_player_count
    bids.select do |bid|
      bid.slug == Bid::PASS
    end.map(&:game_player_id).uniq.size
  end

  def last_finished_trick
    tricks.select { |t| t.cards.size == 4 }.sort_by(&:trick_index).last
  end

  def next_player_by_position(game_player)
    return nil unless game_player

    game_players.find do |p|
      p.position == (game_player.position + 1) % 4
    end
  end

  def last_passed_announcer
    announcements.sort_by(&:id).reverse.find { |a| a.slug == Announcement::PASS }&.game_player
  end

  def bid_lead
    winning_bid&.declarer_leads? ? declarer : forehand
  end

  def set_defenders
    # https://thoughtbot.com/blog/activerecord-s-where-not-and-nil
    game_players.where.not(team: GamePlayer::DECLARERS).or(game_players.where(team: nil)).update(team: GamePlayer::DEFENDERS)
  end
end
