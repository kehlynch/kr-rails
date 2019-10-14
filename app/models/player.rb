class Player < ApplicationRecord
  belongs_to :game

  has_many :cards, -> { where(played_index: nil, discard: false) }
  has_many :discards, -> { where(discard: true) }, class_name: 'Card', foreign_key: 'player_id'
  has_many :bids
  # has_many :led_tricks, class_name: 'Trick', foreign_key: 'lead_player_id'
  # has_many :won_tricks, class_name: 'Trick', foreign_key: 'won_player_id'
  # has_many :won_cards, class_name: 'Card', through: :won_tricks, source: :cards
  
  def self.next_from(player)
    Player.find_by(game: player.game, position: (player.position + 1) % 4)
  end

  def won_tricks
    @won_tricks ||= game.tricks.select { |t| t.won_player == self} if game.stage == :finished
  end

  # this does lots of DB calls - something to optimise
  def won_cards
    won_tricks.map(&:cards).flatten
  end
  
  def trumps_in_hand
    suit_in_hand('trump')
  end

  def suit_in_hand(suit)
    cards.filter { |card| card.suit == suit }
  end

  def points
    (won_cards + discards.to_a).map(&:points).sort.reverse.in_groups_of(3).reduce(0) do |acc, group|
      group.compact!
      total = group.length > 1 ? group.sum + 1 : group.sum
      acc + total
    end
  end

  def forehand?
    human
  end

  def can_bid?
    bids.find_by(slug: 'pass')
  end

  def winner?
    game.winner == self
  end

  def pick_card
    # get random legal card
    legal_cards = cards.select(&:legal)
    if legal_cards.length == 0
      p "NO LEGAL CARDS FOUND"
      p "current_trick cards:"

      p "is it finished? from player? #{game.current_trick.id} #{game.current_trick.cards.length}"
      p self.game.current_trick.cards.length
      p self.game.current_trick.cards
      p "hand:"
      p self.cards.length
      p self.cards
    end
    legal_cards.sample
  end
end
