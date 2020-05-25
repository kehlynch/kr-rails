class Card < ApplicationRecord
  belongs_to :game
  belongs_to :trick, optional: true
  belongs_to :game_player, optional: true

  before_save :record_slug

  TRUMP = 'trump'

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

  def self.trumps
    cards_in_suit(TRUMP)
  end

  def self.cards_in_suit(suit)
    select { |c| c.suit == suit }
  end

  def self.include_slug?(slug)
    find { |c| c.slug == slug }.present?
  end

  def promised_on_trick_index
    case slug
    when 'trump_1'
      11
    when 'trump_2'
      10
    when 'trump_3'
      9
    when /.*_8/
      11
    end
  end

  def points
    if trump?
      TRUMP_POINTS[value] || 0
    else
      NONTRUMP_POINTS[value] || 0
    end
  end

  def trump?
    suit == TRUMP
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

  def legal_putdown?(hand, current_putdowns)
    return false if points == 4

    return true if suit != TRUMP

    simple_legal_putdowns_in_hand = hand.filter { |c| c.suit != TRUMP && c.points != 4 }.length

    trumps_allowed = 3 - simple_legal_putdowns_in_hand

    return false if trumps_allowed <= 0

    trumps_already_put_down = current_putdowns.filter { |h| h.suit == TRUMP }

    return false if trumps_already_put_down >= trumps_allowed

    return true
  end

  def simple_legal_putdown?
    return false if points == 4 || suit == TRUMP

    return true
  end

  def record_slug
    self.slug = "#{suit}_#{value}" if !slug
  end
end
