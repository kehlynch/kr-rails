class Dealer
  def deal(game)
    @cards = []
    (1..8).each do |value|
      %i[club diamond heart spade].each do |suit|
        @cards << Card.build(suit, value)
      end
    end

    (1..22).each do |value|
      @cards << Card.build(:trump, value)
    end

    @cards.shuffle!

    @cards.first(6).in_groups_of(3).each_with_index do |card, i|
      card.talon_half = i
    end

    @cards.last(48).in_groups_of(12).each_with_index do |card, i|
      card.player = game.players[i]
    end
  end
end
