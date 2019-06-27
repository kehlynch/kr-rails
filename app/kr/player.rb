# frozen_string_literal: true

class Player
  def self.deserialize(state)
    id = state['id']
    human = state['human']
    hand = Hand.deserialize(state['hand'])
    points = state['points']
    Player.new(id, hand, human, points)
  end

  def self.players(hands, nohuman = false)
    humans = nohuman ? [] : [0]
    hands.each_with_index.map do |h, i|
      Player.new(i, h, humans.include?(i))
    end
  end

  attr_accessor :id, :hand, :human, :points

  def initialize(id, hand, human = false, points = nil)
    @id = id
    @human = human
    @hand = hand
    @points = points
  end

  def remove_from_hand(card_slug)
    @hand.delete(card_slug)
  end

  def pick_card(tricks)
    # get random legal card
    legal_cards(tricks[-1]).sample
  end

  def legal_cards(trick)
    return @hand.cards if trick&.winning_player_id == @id

    led_suit = trick&.led_suit
    in_led_suit = @hand.cards.select { |c| c.suit == led_suit }
    return in_led_suit unless in_led_suit == []

    trumps = @hand.cards.select { |c| c.suit == :trump }
    return trumps unless trumps == []

    @hand.cards
  end

  def tag_legal_cards(trick)
    legal = legal_cards(trick)
    @hand.cards.map do |c|
      c.legal = trick.finished || !trick.started || legal.include?(c)
    end
  end

  def serialize
    {
      'id' => @id,
      'human' => @human,
      'hand' => @hand.serialize,
      'points' => @points
    }
  end
end
