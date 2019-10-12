class Talon
  def self.deserialize(map)
    cards = map['cards'].map { |half| half.map { |c| LegacyCard.deserialize(c) } }
    Talon.new(cards)
  end

  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def serialize
    { 'cards' => @cards.map { |half| half.map(&:serialize) } }
  end

  def remove_half(index)
    @cards.delete_at(index)
  end
end
