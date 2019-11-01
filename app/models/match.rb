class Match < ApplicationRecord
  has_many :players, -> { order(:id) }
  has_many :games, -> { order(:id) }

  accepts_nested_attributes_for :players

  def deal_game
    Game.deal_game(id, players)
  end

  def earlier_games(game_id)
    games.where('id < ?', game_id)
  end
end
