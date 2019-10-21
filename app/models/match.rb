class Match < ApplicationRecord
  has_many :players
  has_many :games

  def deal_game
    Game.deal_game(id, players)
  end
end
