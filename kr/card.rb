# frozen_string_literal: true

# module for card classes
module Card
  SUITS =
    {
      'club' => :black,
      'diamond' => :red,
      'heart' => :red,
      'spade' => :black,
      'trump' => :trump
    }.freeze

  def get_card(value, suit)
    value = begin
                value.to_i
            rescue StandardError
              CardError.new("Card value #{value} is invalid")
              end

    if !(SUITS[suit])
      raise CardError, "#{suit} is not a valid suit."
    elsif SUITS[suit] == :red
      card = RedCard.new(value, suit)
    elsif SUITS[suit] == :black
      card = BlackCard.new(value, suit)
    elsif SUITS[suit] == :trump
      card = Trump.new(value, suit)
    end

    raise CardError, "#{value} not valid for #{suit} suit." unless card.valid_value?

    card
  end

  class CardError < StandardError; end

  class Card
    attr_reader :suit, :value, :name, :points

    class << self
      attr_reader :name_lookup
    end

    class << self
      attr_reader :point_lookup
    end

    def self.add_name(value, name)
      @name_lookup ||= {}
      @name_lookup[value] = name
    end

    def self.add_points(value, points)
      @point_lookup ||= {}
      @point_lookup[value] = points
    end

    def initialize(value, suit)
      @value = value
      @suit = suit
      @name = get_name
      @points = get_points
    end

    def get_points
      self.class.point_lookup[@value] || 1
    end

    def to_s
      @name
    end
  end

  class Trump < Card
    require 'roman_numerals'

    add_name(1, 'Pagat')
    add_name(2, 'Uhu')
    add_name(3, 'Kakadu')
    add_name(4, 'Maribu')
    add_name(21, 'Mond')
    add_name(22, 'Sküs')

    add_points(1, 5)
    add_points(21, 5)
    add_points(22, 5)

    def valid_value?
      if @value.between?(1, 22)
        true
      else
        false
      end
    end

    def get_name
      result = @value.to_roman
      result << " (#{self.class.name_lookup[@value]})" if self.class.name_lookup[@value]
      result
    end
  end

  class NonTrump < Card
    def self.add_nontrump_names
      add_name(8, 'King')
      add_name(7, 'Queen')
      add_name(6, 'Knight')
      add_name(5, 'Jack')
    end

    def self.add_nontrump_points
      add_points(8, 5)
      add_points(7, 4)
      add_points(6, 3)
      add_points(5, 2)
    end

    def valid_value?
      if @value.between?(1, 8)
        true
      else
        false
      end
    end

    def get_name
      "#{self.class.name_lookup[@value]} of #{@suit.capitalize}s"
    end
  end

  class RedCard < NonTrump
    add_nontrump_names
    add_nontrump_points
    add_name(4, 'Ace')
    add_name(3, '2')
    add_name(2, '3')
    add_name(1, '4')
  end

  class BlackCard < NonTrump
    add_nontrump_names
    add_nontrump_points
    add_name(4, '10')
    add_name(3, '9')
    add_name(2, '8')
    add_name(1, '7')
  end
end
