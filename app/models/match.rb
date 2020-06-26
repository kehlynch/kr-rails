class Match < ApplicationRecord
  has_many :games, -> { order(:id) }, dependent: :destroy
  has_many :match_players
  has_many :players, through: :match_players

  attribute :human_name, :text
  attribute :human_count, :integer

  accepts_nested_attributes_for :players

  def self.open_matches_for(player)
    open_matches.reject { |m| m.players.include?(player) }
  end

  def self.open_matches
    all.order(created_at: :desc).filter do |match|
      match.players.count < 4
    end
  end

  def deal_game
    game = Game.deal_game(id, players)
    Runner.new(game).advance!
    game
  end

  def earlier_games(game_id)
    games.where('id < ?', game_id)
  end

  def stage
    return 'waiting' if players.count < 4

    return 'in progress'
  end

  def points_for(player)
    games.map(&:game_players).flatten.filter do |gp|
      gp.player_id == player.id
    end.map(&:game_points).sum
  end
end
