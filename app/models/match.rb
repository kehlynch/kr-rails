class Match < ApplicationRecord
  has_many :players
  has_many :games, -> { order(:id) }

  def deal_game
    Game.deal_game(id, players)
  end

  def earlier_games(game_id)
    games.where('id < ?', game_id)
  end
end
