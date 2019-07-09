# frozen_string_literal: true

class Card
  def self.deserialize(state)
    suit, value = state['slug'].to_s.split('_')
    player_id = state['player_id']
    legal = state['legal']
    Card.new(suit.to_sym, value.to_i, player_id, legal)
  end

  def self.calculate_points(cards)
    cards.map(&:points).sort.reverse.in_groups_of(3).reduce(0) do |acc, group|
      group.compact!
      total = group.length > 1 ? group.sum + 1 : group.sum
      acc + total
    end
  end

  attr_reader :suit, :value, :name, :slug
  attr_accessor :legal, :player_id

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

  def initialize(suit, value, player_id = nil, legal = true)
    @value = value
    @suit = suit
    @slug = "#{suit}_#{value}".to_sym
    @player_id = player_id
    @legal = legal
  end

  def points
    if @suit == :trump
      TRUMP_POINTS[value] || 0
    else
      NONTRUMP_POINTS[value] || 0
    end
  end

  def <=>(other)
    [other.suit, other.value] <=> [suit, value]
  end

  def serialize
    {
      'slug' => slug,
      'player_id' => player_id,
      'legal' => legal
    }
  end
end
