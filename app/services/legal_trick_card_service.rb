class LegalTrickCardService
  def initialize(hand_cards, trick, bid)
    @card = card
    @trick = trick
    @bid = bid
  end

  def legal?
    return false unless @bid

    return negative_legal? if @bid.negative?

    return false if  illegal_through_announcements?

    if forced_cards.any?
      return true if game_player.forced_cards.include?(slug)

      return false
    end

    return false if game_player.illegal_cards.include?(slug)

    return true if !winning_card # lead a card

    return true if suit == led_suit

    return false if game_player.hand_cards.cards_in_led_suit?

    return true if trump?

    return false if game_player.trumps.length > 0

    return true
  end

  private

  attr_reader :card, :trick

  delegate(
    :game,
    :game_player,
    :slug,
    :suit,
    :trump?,
    to: :card
  )

  delegate(
    :led_suit,
    :winning_card,
    :led_card,
    :trick_index,
    to: :trick
  )

  def illegal_through_bird?
    promised_birds = game_player.promised_birds
    return false unless promised_birds.any?

    # if trumps are otherwise legal and they only have promised bird left, they'll have one of them, so don't mark other cards ilelga
    # TODO: unless they're lead!!
    return false if game_player.hand_cards.trumps.length == promised_birds.length

    promised_birds.any? do |card|
      illegal_through_promised_card?(card)
    end
  end

  def illegal_through_king?
    promised_king = game_player.promised_king

    return false unless game_player.promised_king

    # if it's the last card in this suit, and it's legal, they'll have to play it
    # TODO: unless they're lead!!
    return false

  end

  def illegal_through_promised_card?(promised_card)
    pertinent_trick = promised_card.promised_on_trick_index == trick_index
    pertinent_card = promised_card == @card

    return false if pertinent_trick && pertinent_card

    return true if pertinent_trick || pertinent_card
  end

  def negative_legal?
    winning_card = @trick&.winning_card

    if !winning_card
      # leading pagat
      return false if @card.pagat? && game_player.trumps.length > 1 && @bid.trischaken?

      return true
    end

    play_ups = game_player.suit_cards(winning_card.suit).select { |c| c.value > winning_card.value }

    if suit == led_suit
      return true if winning_card.suit != led.suit

      return true if value > winning_card.value

      return true if play_ups.empty?
    end

    return false if game_player.suit_cards(led_suit).any?

    if trump?
      return true if !winning_card.trump?

      return true if value > winning_card.value

      return true if play_ups.empty?
    end

    return false if game_player.trumps.any?

    return true
  end
end
