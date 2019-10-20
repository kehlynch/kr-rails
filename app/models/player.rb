class Player < ApplicationRecord
  # has_many :cards, -> { where(played_index: nil, discard: false).order([:suit, :value]).reverse }
  has_many :cards, -> { where(played_index: nil, discard: false).order(suit: :desc, value: :desc) }
  has_many :discards, -> { where(discard: true) }, class_name: 'Card', foreign_key: 'player_id'
  has_many :bids

  belongs_to :game

  # has_many :led_tricks, class_name: 'Trick', foreign_key: 'lead_player_id'
  # has_many :won_tricks, class_name: 'Trick', foreign_key: 'won_player_id'
  # has_many :won_cards, class_name: 'Card', through: :won_tricks, source: :cards
  
  def self.next_from(player)
    Player.find_by(game: player.game, position: (player.position + 1) % 4)
  end

  def self.human_player_for(game_id)
    Player.find_by(game_id: game_id, human: true)
  end

  def available_bids(game)
    Bidding.new(game.id).available_bids(self)
  end

  def won_tricks
    game.tricks.select { |t| t.won_player == self}
  end

  # this does lots of DB calls - something to optimise
  def won_cards
    won_tricks.map(&:cards).flatten
  end

  def scorable_cards
    (won_cards + discards).flatten
  end
  
  def trumps_in_hand
    suit_in_hand('trump')
  end

  def suit_in_hand(suit)
    cards.filter { |card| card.suit == suit }
  end

  def human?
    human
  end

  def forehand?
    human?
  end

  def pick_card
    CardPicker.new(hand: cards).pick
  end

  def pick_bid
    available_bids = Bids.new(game_id).available_bids(self)
    BidPicker.new(bids: available_bids, hand: cards).pick
  end

  def pick_talon(_talon)
    [0, 1].sample
  end

  def pick_king()
    ['club_8', 'diamond_8', 'heart_8', 'spade_8'].sample
  end

  def pick_putdowns
    putdowns = []
    until putdowns.length == 3
      putdowns << cards.filter { |c| c.legal_putdown?(cards, putdowns) }.sample
    end

    return putdowns
  end

  def name
    ['Katherine', 'Mary', 'David', 'Clare'][position]
  end
end
