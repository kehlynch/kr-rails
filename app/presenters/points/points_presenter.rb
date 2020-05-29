class Points::PointsPresenter
  def initialize(game, active_player)
    @game = game
    @active_player = active_player
    @match_games = game.match.games.for_scores
    @cumulative_points = cumulative_points
  end

  def props
    {
      player_names: @game.game_players.map(&:name),
      games: games,
    }
  end

  private

  def games
    @match_games.each_with_index.map do |game, index|
      Points::GamePointsPresenter.new(game, @cumulative_points[index]).props
    end
  end

  def cumulative_points
    rp = raw_points

    rp.each_with_index.map do |rp_row, row_index|
      rp_row.each_with_index.map do |point, point_index|
        cumulative_rows = rp[0..row_index]
        cumulative_rows.sum { |cr| cr[point_index] }
      end
    end
  end

  def raw_points
    @match_games.map do |game|
      game.game_players.map(&:game_points)
    end
  end
end
