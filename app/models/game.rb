class Game < ApplicationRecord
  belongs_to :match

  has_many :game_players
  has_many :declarers, -> { where(team: GamePlayer::DECLARERS) }, class_name: 'GamePlayer'
  has_many :defenders, -> { where(team: GamePlayer::DEFENDERS) }, class_name: 'GamePlayer'
  has_one :forehand, -> { where(forehand: true) }, class_name: 'GamePlayer'
  has_one :declarer, -> { where(declarer: true) }, class_name: 'GamePlayer'
  has_one :partner, -> { where(partner: true) }, class_name: 'GamePlayer'

  has_many :cards, -> { includes(:game_player) }, dependent: :destroy
  has_many :talon_cards, -> { where.not(talon_half: nil) }, class_name: 'Card'
  has_many :announcements, -> { includes(:game_player) }, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_one :won_bid, -> { where(won: true) }, class_name: 'Bid'

  has_many :tricks, dependent: :destroy

  has_many :announcement_scores

  default_scope {
    includes(
      :game_players,
      :declarers,
      :defenders,
      :forehand,
      :declarer,
      :partner,
      :bids,
      :won_bid
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
    game.match.players.map do |p|
      forehand = p.position == forehand_position_for(game)
      game.game_players.create(player: p, position: p.position, forehand: forehand, human: p.human, name: p.name)
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
    update(king: nil, talon_picked: nil, talon_resolved: false)
    Runner.new(self).advance!
  end

  def kings
    ['club_8', 'diamond_8', 'heart_8', 'spade_8'].map do |king_slug|
      # don't hit the db here
      cards.find { |c| c.slug == king_slug }
    end
  end

  def talon_service
    TalonService.new(self)
  end

  def talon_halves
    talon_service.talon
  end

  def talon_cards_to_pick
    return nil if won_bid.nil? || !won_bid.talon?

    return 6 if won_bid.slug == Bid::SECHSERDREIER

    return 3
  end

  def bird_required?
    won_bid&.slug == Bid::BESSER_RUFER
  end

  def stages
    [
      [Stage::BID, true],
      [Stage::KING, won_bid&.king?],
      [Stage::PICK_TALON, talon_cards_to_pick.present?],
      [Stage::RESOLVE_TALON, talon_cards_to_pick.present?],
      [Stage::ANNOUNCEMENT, bids.highest&.announcements?],
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

    if bids.second_round_finished?
      bids.highest.update(won: true)
      bids.highest.game_player.update(declarer: true, team: GamePlayer::DECLARERS)
      if !bids.highest.king?
        set_defenders
      end
    end

    return bid
  end

  def make_announcement!(slug = nil)
    return nil if (next_player_human? && !slug) || announcements.finished?

    slug ||= next_player.pick_announcement(valid_announcements)
    return unless valid_announcements.include?(slug)

    announcements.create(slug: slug, game_player: next_player)
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

    card ||= next_player.pick_card_for(current_trick, won_bid)
    card = tricks.add_card!(card)

    if finished?
      PointsService.new(self).record_points
    end

    return card
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
      game_players.next_from(bids.last&.game_player) || forehand
    when Stage::ANNOUNCEMENT
      game_players.next_from(announcements.last_passed_player) || declarer
    when Stage::KING, Stage::PICK_TALON, Stage::RESOLVE_TALON
      declarer
    when Stage::TRICK
      game_players.next_from(current_trick.last_player) ||
        tricks.last_finished_trick&.won_player ||
        bid_lead
    when Stage::FINISHED
      nil
    end
  end

  def current_trick
    tricks.current_trick
  end

  def finished?
    tricks.finished?
  end

  private

  def bid_lead
    bids.highest&.declarer_leads? ? declarer : forehand
  end

  def set_defenders
    # https://thoughtbot.com/blog/activerecord-s-where-not-and-nil
    game_players.where.not(team: GamePlayer::DECLARERS).or(game_players.where(team: nil)).update(team: GamePlayer::DEFENDERS)
  end
end
