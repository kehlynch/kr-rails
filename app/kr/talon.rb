# frozen_string_literal: true

require 'card'

class Talon
  def self.deserialize(map)
    cards = map['cards'].map { |half| half.map { |c| Card.deserialize(c) } }
    Talon.new(cards)
  end

  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def serialize
    { 'cards' => @cards.map { |half| half.map(&:serialize) } }
  end
end
