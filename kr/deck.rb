# frozen_string_literal: true

require 'card'

# class to represent the 54 card tarok deck
class Deck
  include Card
  def initialize
    @deck = []
    (1..8).each do |value|
      %w[club diamond heart spade].each do |suit|
        @deck << Card.get_card(value, suit)
      end
    end

    (1..22).each do |value|
      @deck << Card.get_card(value, 'trump')
    end
  end

  def to_s
    names = []
    @deck.each do |card|
      names << card.to_s
    end
    names.join(', ')
  end

  def sort!
    @deck = @deck.sort_by { |card| [card.suit, card.value] }
    self
  end
end
