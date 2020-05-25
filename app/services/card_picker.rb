class CardPicker
  def initialize(hand:, trick:, bid:, bird_announced:, game_player:)
    @hand = hand
    @trick = trick
    @bid = bid
    @game_player = game_player
    @bird_announced = bird_announced
  end

  def pick
    fail 'trying to pick card when hand is empty' if @hand.empty?

    # TODO:
    legal_cards = LegalTrickCardService.new(@game_player, @trick, @bid).legal_cards

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
