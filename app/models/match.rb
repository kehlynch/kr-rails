class Match < ApplicationRecord
  has_many :games, -> { order(:id) }, dependent: :destroy
  has_many :match_players, -> { order(:id) }
  has_many :players, through: :match_players

  attribute :human_name, :text
  attribute :human_count, :integer

  accepts_nested_attributes_for :players

  def self.open_matches_for(player)
    open_matches.reject { |m| m.players.include?(player) }
  end

  def self.open_matches
    all.order(created_at: :desc).filter do |match|
      match.players.count < 8
    end
  end

  def deal_game
    game = Game.deal_game(id, next_game_players)
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


  def next_game_players
    player_count = match_players.size
    last_forehand_player_id = games.last&.forehand&.player_id
    last_forehand_position = match_players.find_by(player_id: last_forehand_player_id)&.position || -1
    forehand_position = (last_forehand_position + 1) % (player_count)
    players = get_relative_player_positions(player_count).map do |rel_pos|
      pos = (rel_pos + forehand_position) % player_count
      match_players.find_by(position: pos)
    end

    players
  end

  private

  def get_relative_player_positions(player_count)
    case player_count
    when 4, 5
      return [0, 1, 2, 3]
    when 6
      return [0, 2, 3, 4]
    when 7
      return [0, 2, 4, 5]
    end
  end
end
