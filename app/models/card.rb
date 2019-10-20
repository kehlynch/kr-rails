class Card < ApplicationRecord
  belongs_to :game
  belongs_to :player, optional: true
  belongs_to :trick, optional: true


  TRUMP_POINTS = {
    1 => 4,
    21 => 4,
    22 => 4
  }.freeze

  NONTRUMP_POINTS = {
    8 => 4,
    7 => 3,
    6 => 2,
    5 => 1
  }.freeze

  def self.build(game, suit, value)
    Card.create(game: game, suit: suit, value: value, slug: "#{suit}_#{value}")
  end

  def points
    if suit == 'trump'
      TRUMP_POINTS[value] || 0
    else
      NONTRUMP_POINTS[value] || 0
    end
  end


  def legal
    return legal_putdown if game.stage == :resolve_talon

    return nil if discard || played_index

    current_trick = game.current_trick

    # p '1. trick not started - legal' if !current_trick.started?
    return true if !current_trick&.started?

    led_suit = current_trick&.led_suit

    # p '2. card in led suit - legal' if suit == led_suit
    return true if suit == led_suit

    # p '3. other led suit in hand - NOT legal' if player.suit_in_hand(led_suit).length > 0
    return false if player.suit_in_hand(led_suit).length > 0

    # p '4. trump - legal' if suit == 'trump'
    return true if suit == 'trump'

    # p '5. other trumps in hand - NOT legal' if player.trumps_in_hand.length > 0
    return false if player.trumps_in_hand.length > 0

    # TODO: leading pagat
    p '6. fallback - legal'
    return true
  end

  def legal_putdown?(hand, current_putdowns)
    return false if points == 5
    
    return true if suit != 'trump'

    simple_legal_putdowns_in_hand = hand.filter { |c| c.suit != 'trump' && c.points != 5 }.length

    trumps_allowed = 3 - simple_legal_putdowns_in_hand

    return false if trumps_allowed <= 0

    trumps_already_put_down = ( current_putdowns.filter { |h| h.suit == 'trump' } )

    return false if trumps_already_put_down >= trumps_allowed

    return true
  end

  private

  def legal_putdown
    return true
  end
end
