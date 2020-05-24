class Trick < ApplicationRecord
  belongs_to :game
  has_many :cards
  belongs_to :won_player, class_name: 'GamePlayer', foreign_key: 'game_player_id', optional: true

  before_save :record_winning_player

  def self.finished?
    find_by(trick_index: 11, finished: true).present?
  end

  def self.add_card!(card)
    current_trick.add_card!(card)
  end

  def self.current_trick
    last_played_trick = where.not(cards: []).order(trick_index: :desc).first

    last_played_trick || find_by(trick_index: 0)

    # return last_played_trick unless last_played_trick.finished?

    # return find_by(trick_index: last_played_trick.trick_index + 1)
  end

  def self.playable_trick_index
    current_trick.trick_index
  end

  # def self.next_player
  #   return nil if finished?

  #   return current_trick.won_player if current_trick.finished?

  #   # mid trick - find next player
  #   current_trick.next_player
  # end

  def add_card!(card)
    card.update(played_index: next_played_index, trick_id: id)

    cards.reload
    update(finished: true) if cards.size == 4

    return card
  end

  def started?
    cards.size > 0
  end

  def finished?
    finished
  end

  def led_suit
    led_card&.suit
  end

  def find_card(slug)
    # cheap to do in memory so don't hit the DB here
    cards.find { |c| c.slug == slug }
  end

  def winning_card
    cards.max_by do |card|
      # convert to integers to avoid failing array comparison
      is_trump = card.suit == 'trump' ? 1 : 0
      is_led_suit = card.suit == led_suit ? 1 : 0
      [is_trump, is_led_suit, card.value]
    end
  end

  def won_card
    finished? ? winning_card : nil
  end

  def next_player
    return lead_player if cards.empty?

    last_player.next_game_player
  end

  private

  def next_played_index
    (cards.maximum(:played_index) || 0) + 1
  end

  def last_player
    cards[-1]&.game_player
  end

  def previous_trick
    game.tricks.find_by(trick_index: trick_index - 1)
  end

  def lead_player
    return first_trick_lead_player if trick_index == 0

    previous_trick.won_player
  end

  def first_trick_lead_player
    if game.bids.highest&.declarer_leads?
      game.declarer
    else
      game.forehand
    end
  end

  def led_card
    cards[0]
  end

  def record_winning_player
    if finished?
      self.won_player = highest.game_player
    end
  end
end
