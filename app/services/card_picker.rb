class CardPicker
  def initialize(hand:)
    @hand = hand
  end

  def pick
    legal_cards = @hand.select(&:legal)
    legal_cards.sample
  end
end
