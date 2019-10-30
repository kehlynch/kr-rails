class Trick < ApplicationRecord

  belongs_to :game

  has_many :cards, -> { order(:played_index) }

  def add_card(slug, player)
    p '***add_card'
    p slug
    p player.hand
    player.hand.find_card(slug).update(played_index: next_played_index, trick_id: id)

    cards.reload
  end
  
  def find_card(slug)
    cards.find_by(slug: slug)
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
