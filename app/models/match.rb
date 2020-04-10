class Match < ApplicationRecord
  has_many :players, -> { order(:id) }, dependent: :destroy
  has_many :games, -> { order(:id) }, dependent: :destroy

  attribute :human_name, :text
  attribute :human_count, :integer

  accepts_nested_attributes_for :players

  def deal_game
    Game.deal_game(id, players)
  end

  def earlier_games(game_id)
    games.where('id < ?', game_id)
  end

  def stage
    return 'waiting' if players.count < 4

    return 'in progress'
  end
end
