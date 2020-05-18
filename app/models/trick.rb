class Trick < ApplicationRecord
  belongs_to :game
  has_many :cards, -> { order(:played_index) }

  def add_card(card)
    card.update(played_index: next_played_index, trick_id: id)

    cards.reload
    return card
  end

  def find_card(slug)
    cards.find { |c| c.slug == slug }
  end

  def next_played_index
    (cards.maximum(:played_index) || 0) + 1
  end

  def lead_player
    cards[0]&.player
  end

  def won_player
    winning_card.player if finished?
  end

  def won_card
    winning_card if finished?
  end

  def winning_card
    cards.max_by do |card|
      # convert to integers to avoid failing array comparison
      is_trump = card.suit == 'trump' ? 1 : 0
      is_led_suit = card.suit == led_suit ? 1 : 0
      [is_trump, is_led_suit, card.value]
    end
  end

  def winning_player
    winning_card&.player
  end

  # deprecate
  def winning_player_id
    winning_card&.player_id
  end

  def finished?
    cards.length == 4
  end

  def started?
    !cards.empty?
  end

  def last_player
    cards[-1]&.player
  end

  def next_player
    return game.bids.lead if trick_index == 0 && cards.empty?

    return game.players.next_from(last_player) if last_player

    return previous_trick&.won_player if previous_trick&.won_player

    nil
  end

  def previous_trick
    game.tricks.find do |trick|
      trick.trick_index == trick_index - 1
    end
  end

  # deprecate
  def last_player_id
    cards[-1]&.player_id
  end

  def led_card
    cards[0]
  end

  def led_suit
    led_card&.suit
  end
end
