class Player < ApplicationRecord
  has_many :cards, -> { where(played_index: nil, discard: false).order(suit: :desc, value: :desc) }
  has_many :discards, -> { where(discard: true) }, class_name: 'Card', foreign_key: 'player_id'

  belongs_to :match

  has_many :games, through: :match

  def human?
    human
  end

  def name
    ['Katherine', 'Mary', 'David', 'Clare'][position]
  end

  def forehand_for?(game_id)
    # position 0 starts as forehand, round 1 each game
    position == (match.earlier_games(game_id).count) % 4
  end
end
