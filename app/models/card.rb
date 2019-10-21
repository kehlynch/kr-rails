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


  def legal?
    return simple_legal_putdown? if ['resolve_talon', 'resolve_whole_talon'].include?(game.stage)

    return nil if discard || played_index


    current_trick = game.current_trick

    return trischaken_legal? if Bids.new(game_id).highest&.trischaken?

    # p '1. trick not started - legal' if !current_trick.started?
    return true if !current_trick&.started?

    led_suit = current_trick&.led_suit

    # p '2. card in led suit - legal' if suit == led_suit
    return true if suit == led_suit

    # p '3. other led suit in hand - NOT legal' if player.suit_in_hand(led_suit).length > 0
    return false if player.suit_in_hand_for(game_id, led_suit).length > 0

    # p '4. trump - legal' if suit == 'trump'
    return true if suit == 'trump'

    # p '5. other trumps in hand - NOT legal' if player.trumps_in_hand.length > 0
    return false if player.trumps_in_hand_for(game_id).length > 0

    return true
  end

  def trischaken_legal?
    led = game.current_trick&.led_card

    winning = game.current_trick&.winning_card

    p led
    p winning

    if !led
      # leading pagat
      return false if slug == 'trump_1' && player.trumps_in_hand_for(game_id).length > 1

      return true
    end

    play_ups = player.suit_in_hand_for(game_id, winning.suit).select { |c| c.value > winning.value }

    if suit == led.suit
      return true if winning.suit != led.suit
    
      return true if value > winning.value

      return true if play_ups.empty?
    end

    return false if player.suit_in_hand_for(game_id, led.suit).any?

    if suit == 'trump'
      return true if winning.suit != 'trump'

      return true if value > winning.value

      return true if play_ups.empty?
    end

    return false if player.trumps_in_hand_for(game_id).any?

    return true
  end

  def legal_putdown?(hand, current_putdowns)
    return false if points == 4
    
    return true if suit != 'trump'

    simple_legal_putdowns_in_hand = hand.filter { |c| c.suit != 'trump' && c.points != 4 }.length

    trumps_allowed = 3 - simple_legal_putdowns_in_hand

    return false if trumps_allowed <= 0

    trumps_already_put_down = ( current_putdowns.filter { |h| h.suit == 'trump' } )

    return false if trumps_already_put_down >= trumps_allowed

    return true
  end

  def simple_legal_putdown?
    return false if points == 4 || suit == 'trump'
    
    return true
  end
end
