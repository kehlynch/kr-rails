class Trick < ApplicationRecord
  belongs_to :game
  has_many :cards, -> { order(:played_index) }
  belongs_to :won_player, class_name: 'GamePlayer', foreign_key: 'game_player_id', optional: true

  before_save :record_won_player

  def self.finished?
    find_by(trick_index: 11, finished: true).present?
  end

  def self.add_card!(card)
    current_trick.add_card!(card)
  end

  def self.current_trick
    # https://solidfoundationwebdev.com/blog/posts/how-to-find-records-based-on-has_many-relationship-being-empty-or-not-in-rails
    last_played_trick = joins(:cards).reorder(:trick_index).last

    return find_by(trick_index: 0) unless last_played_trick

    return find_by(trick_index: last_played_trick.trick_index + 1) if last_played_trick.finished?

    return last_played_trick
  end

  def self.last_finished_trick
    joins(:cards).group('tricks.id').having('count(trick_id) = 4').reorder(:trick_index).last
  end

  def self.playable_trick_index
    current_trick&.trick_index
  end

  def add_card!(card)
    card.update(played_index: next_played_index, trick_id: id)

    cards.reload
    update(finished: true) if cards.size == 4

    return card
  end

  def led_card
    cards[0]
  end

  def led_suit
    led_card&.suit
  end

  def last_player
    cards[-1]&.game_player
  end

  def started?
    cards.size > 0
  end

  def finished?
    finished
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

  private

  def next_played_index
    (cards.maximum(:played_index) || 0) + 1
  end

  def record_won_player
    if finished?
      self.won_player = won_card.game_player
    end
  end
end
