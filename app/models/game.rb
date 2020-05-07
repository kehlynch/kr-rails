class Game < ApplicationRecord
  belongs_to :match
  has_many :cards, dependent: :destroy
  has_many :_announcements, -> { order(:id) }, class_name: 'Announcement', dependent: :destroy
  has_many :_bids, -> { order(:id) }, class_name: 'Bid', dependent: :destroy
  has_many :_tricks, class_name: 'Trick', dependent: :destroy

  def self.deal_game(match_id, players)
    game = Game.create(match_id: match_id)
    Dealer.deal(game, players)

    return game
  end

  def self.reset!(game_id)
    Bid.where(game_id: game_id).destroy_all
    Announcement.where(game_id: game_id).destroy_all
    Trick.where(game_id: game_id).destroy_all
    Card.where(game_id: game_id).each do |card|
      card.update(discard: false, trick_id: nil, played_index: nil)
      if card.talon_half
        card.update(player_id: nil)
      end
    end
    Game.update(king: nil, talon_picked: nil, talon_resolved: false)
    Runner.new(Game.find(game_id)).advance!
  end

  def bids
    @bids ||= Bids.new(_bids, self)
  end

  def tricks
    @tricks ||= Tricks.new(_tricks, self)
  end

  def players
    @players ||= GamePlayers.new(self)
  end

  def talon
    @talon ||= Talon.new(cards, self)
  end

  def player_teams
    @player_teams ||= PlayerTeams.new(self)
  end

  def announcements
    @announcements ||= Announcements.new(_announcements, self)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def stage
    return 'make_bid' unless bids.finished?

    return 'pick_king' if bids.pick_king? && king.nil?

    unless bids.talon_cards_to_pick.nil?
      unless talon_picked
        return 'pick_whole_talon' if bids.talon_cards_to_pick == 6

        return 'pick_talon'
      end

      unless talon_resolved
        return 'resolve_whole_talon' if bids.talon_cards_to_pick == 6

        return 'resolve_talon'
      end
    end

    return 'make_announcement' if bids.highest&.announcements? && !announcements.finished?

    unless tricks.finished?
      return 'play_card'
    end

    return 'finished'
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def winners
    player_teams.winners
  end

  def team_for(player)
    player_teams.team_for(player)
  end

  def make_bid!(bid_slug = nil)
    bids.make_bid!(bid_slug)
  end

  def pick_king!(king_slug)
    return if declarer_human? && !king_slug

    self.king = king_slug || declarer.pick_king

    save
  end

  def pick_talon!(talon_half_index)
    return if declarer_human? && talon_half_index.nil?

    talon.pick_talon!(talon_half_index, declarer)

    update(talon_picked: talon_half_index)
  end

  def pick_whole_talon!
    talon.pick_whole_talon!(declarer)

    # TODO: using 3 to mean all 6, since this is an int field and used to refer to the talon_half_index - sort this out!
    update(talon_picked: 3)
  end

  def resolve_talon!(putdown_card_slugs)
    return if declarer_human? && putdown_card_slugs.blank?

    talon.resolve_talon!(putdown_card_slugs, declarer)

    update(talon_resolved: true)
  end

  def play_tricks!(card_slug = nil)
    tricks.play_tricks!(card_slug)
  end

  def human_player
    players.human_player
  end

  def next_player_human?
    next_player&.human?
  end

  def next_player
    if stage == 'make_bid'
      return bids.next_bidder
    elsif stage == 'make_announcement'
      return announcements.next_bidder
    elsif ['pick_king', 'pick_talon', 'pick_whole_talon', 'resolve_talon', 'resolve_whole_talon'].include?(stage)
      return declarer
    elsif ['play_card', 'play_card', 'next_trick'].include?(stage)
      return tricks.next_player
    elsif stage == 'finished'
      return nil
    end
  end

  def forehand
    players.forehand
  end

  def human_forehand?
    forehand.human?
  end

  def declarer
    bids.declarer
  end

  def declarer_human?
    declarer&.human?
  end

  def partner
    player_teams.partner
  end

  def current_trick
    tricks.current_trick
  end

  def current_trick_finished?
    tricks.current_trick_finished?
  end
  
  def finished?
    tricks.finished?
  end

  def partner_known_by?(player_id)
    return false unless bids.finished?

    return true if partner&.id == player_id

    king_in_talon = talon.find { |c| c.slug == king }
    return true if king_in_talon && bids.highest.talon?

    king_played = cards.find do |c|
      c.trick_id.present? && c.slug == king
    end.present?

    return king_played
  end

  private

end
