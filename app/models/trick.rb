class Trick < ApplicationRecord

  belongs_to :game

  has_many :cards, -> { order(:played_index) }

  def self.finished?(game)
    game.tricks.length == 12 && game.tricks[-1].finished?
  end

  def lead_player
    cards[0]&.player
  end

  def won_player
    winning_card.player if finished?
  end

  def winning_card
    self.cards.max_by do |card|
      # convert to integers to avoid failing array comparison
      is_trump = card.suit == 'trump' ? 1 : 0
      is_led_suit = card.suit == led_suit ? 1 : 0
      [is_trump, is_led_suit, card.value]
    end
  end

  def winning_player
    winning_card&.player
  end

  # deprecate
  def winning_player_id
    winning_card&.player_id
  end

  def finished?
    cards.length == 4
  end

  def started?
    !cards.empty?
  end

  def last_player
    cards[-1]&.player
  end

  # deprecate
  def last_player_id
    cards[-1]&.player_id
  end

  def led_suit
    cards[0]&.suit
  end
end
