class Player < ApplicationRecord
  POSITIONS = [0, 1, 2, 3]
  has_many :game_players
  has_many :games, through: :game_players
  has_many :match_players
  has_many :matches, -> { order(created_at: :desc) }, through: :match_players

  before_save do |player|
    if player.name.blank?
      player.name = Names::NAMES.sample
    end
  end

  def human?
    human
  end

  def points
    game_players.map(&:game_points).sum
  end

  def game_count
    games.count
  end
end
