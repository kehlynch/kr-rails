class Player < ApplicationRecord
  has_many :cards, -> { where(played_index: nil, discard: false).order(suit: :desc, value: :desc) }
  has_many :discards, -> { where(discard: true) }, class_name: 'Card', foreign_key: 'player_id'
  has_many :bids

  belongs_to :match

  has_many :games, through: :match

  def human?
    human
  end

  def won_tricks_for(game_id)
    Tricks.new(game_id).select { |t| t.won_player == self }
  end

  def won_cards_for(game_id)
    won_tricks_for(game_id).map(&:cards).flatten
  end

  def scorable_cards_for(game_id)
    (won_cards_for(game_id) + discards.where(game_id: game_id)).flatten
  end

  def cards_for(game_id)
    cards.where(game_id: game_id)
  end
  
  def bids_for(game_id)
    bids.where(game_id: game_id)
  end

  def game_points_for(game_id)
    PlayerTeams.new(game_id).game_points_for(self)
  end

  def individual_points_for(game_id)
    Points.individual_points_for(self, game_id)
  end

  def winner_for?(game_id)
    PlayerTeams.new(game_id).winner?(self)
  end

  def declarer_for?(game_id)
    PlayerTeams.new(game_id).declarer?(self)
  end

  def pick_putdowns_for(game_id)
    putdowns = []
    putdown_count = cards_for(game_id).length - 12
    until putdowns.length == putdown_count
      putdowns << cards.filter { |c| c.legal_putdown?(cards, putdowns) }.sample
    end

    return putdowns
  end
  
  def trumps_in_hand_for(game_id)
    suit_in_hand_for(game_id, 'trump')
  end

  def suit_in_hand_for(game_id, suit)
    cards_for(game_id).where(suit: suit)
  end

  def forehand_for?(game_id)
    # position 0 starts as forehand, round 1 each game
    position == (match.earlier_games(game_id).count) % 4
  end

  def pick_card_for(game_id)
    CardPicker.new(hand: cards_for(game_id)).pick
  end

  def pick_bid_for(game_id, valid_bids)
    BidPicker.new(bids: valid_bids, hand: cards_for(game_id)).pick
  end

  def pick_talon_for(_talon, game_id)
    [0, 1].sample
  end

  def pick_king_for(game_id)
    ['club_8', 'diamond_8', 'heart_8', 'spade_8'].sample
  end

  def name
    ['Katherine', 'Mary', 'David', 'Clare'][position]
  end
end
