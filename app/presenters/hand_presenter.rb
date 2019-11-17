class HandPresenter
  def initialize(cards)
    @cards = cards
  end

  def sorted
    display_order = ['trump', 'heart', 'spade', 'diamond', 'club']
    @cards.sort_by do |c|
      [display_order.index(c.suit), -c.value]
    end
  end
end
