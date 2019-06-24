# frozen_string_literal: true

require 'card'

class Deck
  attr_reader :hands, :talon

  def initialize
    build_deck
    deal
  end

  def build_deck
    @cards = []
    (1..8).each do |value|
      %i[club diamond heart spade].each do |suit|
        @cards << Card.new(suit, value)
      end
    end

    (1..22).each do |value|
      @cards << Card.new(:trump, value)
    end
  end

  def deal
    dealt = @cards.shuffle!.in_groups_of(12).each_with_index.map do |cards, i|
      if i < 4
        Hand.new(cards, i)
      else
        Talon.new(cards.compact.in_groups_of(3).map(&:sort))
      end
    end
    @talon = dealt.pop
    @hands = dealt
  end
end
