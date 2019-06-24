# frozen_string_literal: true

class Trick
  def self.deserialize(state)
    cards = state['cards'].map { |c| Card.deserialize(c) }
    Trick.new(cards)
  end

  attr_reader :cards

  def initialize(cards = [])
    @cards = cards
  end

  def add(card)
    @cards.append(card)
    self
  end

  def winning_card
    @cards.max_by do |card|
      # convert to integers to avoid failing array comparison
      trump = card.suit == :trump ? 1 : 0
      led_suit = card.suit == led_suit ? 1 : 0
      [trump, led_suit, card.value]
    end
  end

  def winning_player_position
    winning_card.player_position
  end

  def finished
    @cards.length == 4
  end

  def started
    !@cards.empty?
  end

  def last_player
    @cards[-1]&.player
  end

  def led_suit
    @cards[0]&.suit
  end

  def serialize
    {
      'cards' => @cards.map(&:serialize)
    }
  end
end
