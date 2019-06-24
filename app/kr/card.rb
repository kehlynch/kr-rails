# frozen_string_literal: true

class Card
  def self.deserialize(state)
    suit, value = state['slug'].split('_')
    player = state['player']
    legal = state['legal']
    Card.new(suit.to_sym, value.to_i, player, legal)
  end

  def self.calculate_points(cards)
    cards.map(&:points).in_groups_of(3).reduce(0) do |group, points|
      total = group.length == 3 ? group.sum - 2 : group.sum - 1
      points + total
    end
  end

  attr_reader :suit, :value, :name, :slug
  attr_accessor :legal

  TRUMP_POINTS = {
    1 => 5,
    21 => 5,
    22 => 5
  }.freeze

  NONTRUMP_POINTS = {
    8 => 5,
    7 => 4,
    6 => 3,
    5 => 2
  }.freeze

  def initialize(suit, value, player = nil, legal = true)
    @value = value
    @suit = suit
    @slug = "#{suit}_#{value}"
    @player = player
    @legal = legal
  end

  def points
    if @suit == :trump
      TRUMP_POINTS[value] || 1
    else
      NONTRUMP_POINTS[value] || 1
    end
  end

  def <=>(other)
    [other.suit, other.value] <=> [suit, value]
  end

  def serialize
    {
      'slug' => slug,
      'player' => player,
      'legal' => legal
    }
  end
end
