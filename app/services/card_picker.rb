class CardPicker
  def initialize(hand:)
    raise if hand.empty?
    @hand = hand
  end

  def pick
    legal_cards = @hand.select(&:legal?)
    p 'legal_cards'
    p legal_cards
    legal_cards.sample
  end
end
