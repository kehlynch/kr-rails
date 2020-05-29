class LegalTrickCardService
  attr_reader :legal_mapping

  def initialize(game, game_player, trick)
    @game = game
    @game_player = game_player
    @trick = trick

    @cards = game_player.hand_cards
    @bid = game.won_bid
    @king = game.king

    @legal_mapping = @cards.map { |c| [c, false] } .to_h
    if @bid && @trick.cards.none? { |c| c.game_player == @game_player }
      generate_legal_mapping
    end
  end

  def legal?(card)
    @legal_mapping[card]
  end

  def legal_cards
    @legal_mapping.select { |k, v| v }.keys
  end

  private

  attr_reader :game, :trick, :cards, :game_player

  delegate(:declarers, :defenders, to: :game)

  delegate(:led_suit, :winning_card, :led_card, :trick_index, to: :trick)

  def generate_legal_mapping
    if @bid.negative?
      update_negative_legal
    else
      update_positive_legal
    end
  end

  def lead?
    led_card.blank?
  end

  def set_trumps_legal(except_pagat = false)
    # https://makandracards.com/makandra/36475-ruby-how-to-update-all-values-of-a-hash
    @legal_mapping.update(@legal_mapping) { |k, v| k.trump? && (!except_pagat || k.slug != 'trump_1') }
  end

  def set_all_cards_legal(except_pagat = false)
    @legal_mapping.update(@legal_mapping) { |k, v| !except_pagat || k.slug != 'trump_1' }
  end

  def set_all_cards_illegal_except(card)
    @legal_mapping.update(@legal_mapping) { |k, v| k == card }
  end
  
  def set_legal(card)
    @legal_mapping[card] = true
  end

  def set_illegal(card)
    @legal_mapping[card] = false
  end

  def no_cards_legal?
    @legal_mapping.values.none?
  end

  def legal_card_count
    @legal_mapping.select { |k, v| v }.count
  end

  def update_negative_nonlead_legal
    led_suit_cards = cards_in_suit(led_suit)
    winning_card_in_led_suit = winning_card.suit == led_suit
    legal_led_suit_cards =
      winning_card_in_led_suit ? 
        led_suit_cards.select { |c| c.value > winning_card.value } :
        led_suit_cards

    if legal_led_suit_cards.any? # play up if possible
      legal_led_suit_cards.each { |c| set_legal(c) }
    elsif led_suit_cards.any?
      led_suit_cards.each { |c| set_legal(c) }
    elsif trumps.any?
      set_trumps_legal(except_pagat: @bid.trischaken?)
    else
      set_all_cards_legal(except_pagat: @bid.trischaken?)
    end

    # Pagat the only trump left in Trischaken - this shouldn't happen otherwise
    if no_cards_legal?
      pagat = @cards.find { |c| c.slug == 'trump_1' }
      @legal_mapping[pagat] = true
    end
  end

  def update_negative_legal
    p led_card
    p @cards.map { |c| c.slug }
    if lead? && @bid.trischaken?
      set_all_cards_legal(except_pagat: @bid.trischaken?)
    elsif lead?
      set_all_cards_legal
    else
      update_negative_nonlead_legal
    end

    fail 'found no legal cards for negative bid' if no_cards_legal?
  end

  def update_positive_legal
    update_simple_positive_legal

    update_legal_from_promised_cards

    fail 'found no legal cards for positiive bid' if no_cards_legal?
  end

  def update_simple_positive_legal
    return set_all_cards_legal if lead?

    led_suit_cards = cards_in_suit(led_suit)

    if led_suit_cards.any?
      led_suit_cards.each { |c| set_legal(c) }
    elsif trumps.any?
      set_trumps_legal
    else
      set_all_cards_legal
    end
  end

  def update_legal_from_promised_cards
    if promised_cards.any?
      promised_cards.each do |promised_card|
        pertinent_trick = promised_card.promised_on_trick_index == trick_index
        if pertinent_trick && legal?(promised_card)
          set_all_cards_illegal_except(promised_card)
        elsif !pertinent_trick && legal?(promised_card)
          set_illegal(promised_card)
        end
      end

      # if we have to play a promised card, reset everything as if nothing was promised.
      update_simple_position_legal if no_cards_legal?
    end
  end

  def promised_cards
    promised_card_slugs = {
      Announcement::PAGAT => 'trump_1',
      Announcement::UHU => 'trump_2',
      Announcement::PAGAT => 'trump_3',
      Announcement::KING => @king
    }.select do |ann_slug, _card_slug|
      team_members.map(&:announcements).flatten.any? { |a| a.slug == ann_slug }
    end.values

    game_player.hand_cards.select { |c| c.slug == promised_card_slugs }
  end

  def team_members
    @game.team_for(@game_player)
  end

  def trumps
    cards_in_suit(Card::TRUMP)
  end

  def cards_in_suit(suit)
    @cards.select { |c| c.suit == suit }
  end
end
