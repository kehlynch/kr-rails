class CardPicker
  def initialize(hand:, bird_announced:)
    @hand = hand
    @bird_announced = bird_announced
  end

  def pick
    fail 'trying to pick card when hand is empty' if @hand.empty?

    # TODO:
    # legal_cards = @hand.select(&:legal?)

    # TODO: stop the bots leading trumps till they're out when declarer
    if @bird_announced && legal_cards.any?(&:trump?)
      return legal_cards.select(&:trump?).sample if perc(80)
    end
    card = legal_cards.sample
    fail 'no legal card' unless card

    return card
  end

  private

  def perc(percentage)
    rand > percentage / 100
  end
end
