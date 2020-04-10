class Player < ApplicationRecord
  POSITIONS = [0, 1, 2, 3]
  has_many :cards, -> { where(played_index: nil, discard: false).order(suit: :desc, value: :desc) }
  has_many :discards, -> { where(discard: true) }, class_name: 'Card', foreign_key: 'player_id'

  belongs_to :match, optional: true

  has_many :games, through: :match

  before_save do |player|
    if player.name.blank?
      player.name = Names::NAMES.reject { |n| match.players.map(&:name).include?(n) }.sample
    end
  end

  def human?
    human
  end

  def forehand_for?(game_id)
    # position 0 starts as forehand, round 1 each game
    position == (match.earlier_games(game_id).count) % 4
  end
end
