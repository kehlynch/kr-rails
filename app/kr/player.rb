# frozen_string_literal: true

class Player
  def self.deserialize(state)
    position = state['position']
    human = state['human']
    hand = Hand.deserialize(state['hand'])
    points = state['points']
    Player.new(position, hand, human, points)
  end

  def self.players(hands)
    humans = [0]
    hands.each_with_index.map do |h, i|
      Player.new(i, h, humans.include?(i))
    end
  end

  attr_accessor :position, :hand, :human, :points

  def initialize(position, hand, human = false, points = nil)
    @position = position
    @human = human
    @hand = hand
    @points = points
  end

  def remove_from_hand(card_slug)
    @hand.delete(card_slug)
  end

  def pick_card(tricks)
    led_suit = tricks[-1]&.led_suit
    # get random legal card
    legal_cards(led_suit).sample
  end

  def legal_cards(led_suit)
    in_led_suit = @hand.cards.select { |c| c.suit == led_suit }
    return in_led_suit unless in_led_suit == []

    trumps = @hand.cards.select { |c| c.suit == :trump }
    return trumps unless trumps == []

    @hand.cards
  end

  def tag_legal_cards(trick)
    legal = legal_cards(trick.led_suit)
    @hand.cards.each do |c|
      c.legal = trick.finished || legal.include?(c)
    end
  end

  def serialize
    {
      'position' => @position,
      'human' => @human,
      'hand' => @hand.serialize,
      'points' => @points
    }
  end
end
