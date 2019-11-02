class CardPicker
  def initialize(hand:, bird_announced:)
    raise if hand.empty?
    @hand = hand
    @bird_announced = bird_announced
  end

  def pick
    legal_cards = @hand.select(&:legal?)
    if @bird_announced && legal_cards.any?(&:trump?)
      return legal_cards.select(&:trump?).sample if perc(80)
    end
    legal_cards.sample
  end

  private

  def perc(percentage)
    rand > percentage/100
  end
end
