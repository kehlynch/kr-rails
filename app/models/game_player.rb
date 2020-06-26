class GamePlayer <  ApplicationRecord
  DECLARERS = 'declarers'
  DEFENDERS = 'defenders'

  validates :team, inclusion: { in: [DECLARERS, DEFENDERS] }, allow_nil: true

  belongs_to :player
  belongs_to :game

  has_many :cards
  has_many :discards, -> { where(discard: true) }, class_name: 'Card'
  has_many :won_tricks, class_name: 'Trick'

  has_many :announcements
  has_many :bids

  has_many :co_players, through: :game, source: :game_players

  def hand_cards
    cards.select do |c|
      c.trick_id.nil? && !c.discard
    end
  end

  def original_hand_cards
    cards.select do |c|
      c.talon_half.nil?
    end
  end

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

  def announced?(slug)
    announcements.find { |a| a.slug == slug }.present?
  end

  def pick_putdowns
    putdown_count = hand_cards.length - 12
    putdowns =
      hand_cards.filter do |c|
        c.legal_putdown?(hand_cards, putdowns)
      end.sample(putdown_count).flatten

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
end
