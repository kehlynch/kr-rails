# frozen_string_literal: true

require 'card'

class Hand
  def self.deserialize(state)
    cards = state['cards'].map do |s|
      Card.deserialize(s)
    end
    player = state['player']
    Hand.new(cards, player)
  end

  attr_reader :player, :cards

  def initialize(cards = [], player = nil)
    @cards = cards.sort.map do |card|
      card.player = player
      card
    end
    @player = player
  end

  def delete(card_slug)
    card = @cards.find { |c| c.slug == card_slug }
    @cards.delete(card)
  end

  def serialize
    {
      'cards' => @cards.map(&:serialize),
      'player' => player
    }
  end
end
