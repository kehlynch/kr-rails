class Dealer
  def self.deal(game, players)
    @cards = []
    (1..8).each do |value|
      %i[club diamond heart spade].each do |suit|
        @cards << Card.build(game, suit, value)
      end
    end

    (1..22).each do |value|
      @cards << Card.build(game, :trump, value)
    end

    @cards.shuffle!

    talon = @cards.first(6)
    talon.first(3).each do |card|
      card.update(talon_half: 0)
    end

    talon.last(3).each do |card|
      card.update(talon_half: 1)
    end

    @cards.last(48).in_groups_of(12).each_with_index do |hand_cards, i|
      hand_cards.each { |c| c.update(player: players[i]) }
    end

    @cards.each(&:save!)
  end
end
