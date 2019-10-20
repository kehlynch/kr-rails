class Match < ApplicationRecord
  has_many :players

  def deal_game
    Game.deal_game(id, players)
  end
end
