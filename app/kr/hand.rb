# frozen_string_literal: true

require 'card'

class Hand
  def self.deserialize(state)
    cards = state['cards'].map do |s|
      Card.deserialize(s)
    end
    player_id = state['player_id']
    Hand.new(cards, player_id)
  end

  attr_reader :player_id, :cards

  def initialize(cards = [], player_id = nil)
    @cards = cards.sort.map do |card|
      card.player_id = player_id
      card
    end
    @player_id = player_id
  end

  def serialize
    {
      'cards' => @cards.map(&:serialize),
      'player_id' => @player_id
    }
  end

  def delete(card_slug)
    card = find_by_slug(card_slug)
    raise 'card not found in hand' unless card

    @cards.delete(card)
  end

  def add(new_cards)
    @cards += new_cards
  end

  def include?(card_slug)
    find_by_slug(card_slug).present?
  end

  private

  def find_by_slug(card_slug)
    @cards.find { |c| c.slug == card_slug }
  end

end
