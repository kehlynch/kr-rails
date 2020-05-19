class Card < ApplicationRecord
  belongs_to :game
  belongs_to :trick, optional: true
  belongs_to :game_player, optional: true

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

  # def player
  #   game_player
  # end

  # def player_id
  #   game_player&.id
  # end

  def self.build(game, suit, value)
    Card.create(game: game, suit: suit, value: value, slug: "#{suit}_#{value}")
  end

  def points
    if trump?
      TRUMP_POINTS[value] || 0
    else
      NONTRUMP_POINTS[value] || 0
    end
  end

  def trump?
    suit == 'trump'
  end

  def pagat?
    slug == 'trump_1'
  end

  def uhu?
    slug == 'trump_2'
  end

  def kakadu?
    slug == 'trump_3'
  end

  def bird?
    ['trump_1', 'trump_2', 'trump_3'].include?(slug)
  end

  def hand
    game_player.hand
  end

  def called_king?
    game.king == slug
  end

  def legal?
    return legal_for_trick?
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def legal_for_trick?(trick = current_trick)
    return negative_legal? if game.bids.highest&.negative?

    if game_player.forced_cards.any?
      return true if game_player.forced_cards.include?(slug)

      return false
    end

    return false if game_player.illegal_cards.include?(slug)

    return true if !trick.winning_card # lead a card

    return true if suit == led_suit

    return false if hand.cards_in_led_suit?

    return true if suit == 'trump'

    return false if game_player.trumps.length > 0

    return true
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  # rubocop:disable Metrics/CyclomaticComplexity
  def negative_legal?
    winning_card = game.current_trick&.winning_card

    if !winning_card
      # leading pagat
      return false if slug == 'trump_1' && game_player.trumps.length > 1 && game.bids.highest&.trischaken?

      return true
    end

    led = game.current_trick&.led_card

    play_ups = game_player.suit_cards(winning_card.suit).select { |c| c.value > winning_card.value }

    if suit == led.suit
      return true if winning_card.suit != led.suit

      return true if value > winning_card.value

      return true if play_ups.empty?
    end

    return false if game_player.suit_cards(led.suit).any?

    if suit == 'trump'
      return true if winning_card.suit != 'trump'

      return true if value > winning_card.value

      return true if play_ups.empty?
    end

    return false if game_player.trumps.any?

    return true
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def legal_putdown?(hand, current_putdowns)
    return false if points == 4

    return true if suit != 'trump'

    simple_legal_putdowns_in_hand = hand.filter { |c| c.suit != 'trump' && c.points != 4 }.length

    trumps_allowed = 3 - simple_legal_putdowns_in_hand

    return false if trumps_allowed <= 0

    trumps_already_put_down = current_putdowns.filter { |h| h.suit == 'trump' }

    return false if trumps_already_put_down >= trumps_allowed

    return true
  end

  def simple_legal_putdown?
    return false if points == 4 || suit == 'trump'

    return true
  end

  def only_legal_card
    if current_trick.trick_index == 12
      return if player_has_announced?(Announcements::KING) && hand.has_called_king?
    end

    if player_has_announced?(Announcements::PAGAT) && hand.find_by(slug: 'trump_1').present?
      return true
    end
  end

  def player_has_announced?(announcement_slug)
    game_player.team_announcements.include?(announcement_slug)
  end

  def current_trick
    game.current_trick
  end

  def led_suit
    current_trick&.led_suit
  end
end
