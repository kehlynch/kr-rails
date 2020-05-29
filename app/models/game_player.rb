class GamePlayer <  ApplicationRecord
  DECLARERS = 'declarers'
  DEFENDERS = 'defenders'

  validates :team, inclusion: { in: [DECLARERS, DEFENDERS] }, allow_nil: true

  belongs_to :player
  belongs_to :game

  has_many :cards
  has_many :hand_cards, -> { where(trick_id: nil, discard: false) }, class_name: 'Card'
  has_many :original_hand_cards, -> { where(talon_half: nil) }, class_name: 'Card'
  has_many :discards, -> { where(discard: true) }, class_name: 'Card'
  has_many :won_tricks, class_name: 'Trick'

  has_many :announcements
  has_many :bids
  has_many :tricks

  has_many :co_players, through: :game, source: :game_players

  def forehand?
    forehand
  end

  def declarer?
    declarer
  end

  def team_members
    game.game_players.where(team: team)
  end

  # TODO: this might be really inefficient
  def played_in?(trick)
    return false unless trick

    trick.cards.find { |c| c.game_player_id == id }
  end

  def played_in_any_trick?
    cards.select(&:trick_id).any?
  end

  def scorable_cards
    (won_cards + discards).flatten
  end

  def promised_cards
    promised_card_slugs = {
      Announcement::PAGAT => 'trump_1',
      Announcement::UHU => 'trump_2',
      Announcement::PAGAT => 'trump_3',
      Announcement::KING => game.king
    }.select do |ann_slug, _card_slug|
      team_announced?(ann_slug)
    end.values

    hand_cards.where(slug: promised_card_slugs)
  end

  def announced?(slug)
    announcements.find { |a| a.slug == slug }.present?
  end

  def pick_putdowns
    putdowns = []
    putdown_count = hand_cards.length - 12
    until putdowns.length == putdown_count
      putdowns << hand_cards.filter do |c|
        c.legal_putdown?(hand_cards, putdowns)
      end.sample
    end

    return putdowns
  end

  def pick_bid(valid_bids)
    BidPicker.new(bids: valid_bids, hand: hand_cards).pick
  end

  def pick_announcement(_valid_announcements)
    bird_required = game.bird_required? && declarer?
    AnnouncementPicker.new(
      hand: hand_cards,
      bird_required: bird_required && !announced_bird?
    ).pick
  end

  def announced_bird?
    ['pagat', 'uhu', 'kakadu'].any? { |a| announced?(a) }
  end

  def pick_card_for(trick, bid)
    return nil unless hand_cards.any?

    # TODO this needs to check if the team announced them - current just checks if this player did
    bird_announced = ['pagat', 'uhu', 'kakadu'].any? { |a| announced?(a) }
    CardPicker.new(hand: hand_cards, trick: trick, bid: bid, bird_announced: bird_announced, game_player: self).pick
  end

  def pick_talon
    [0, 1].sample
  end

  def pick_king
    ['club_8', 'diamond_8', 'heart_8', 'spade_8'].sample
  end

  private

  def won_cards
    won_tricks.map(&:cards).flatten
  end

  def team_announced?(slug)
    team_members.any? { |gp| gp.announced?(slug) }
  end
end
