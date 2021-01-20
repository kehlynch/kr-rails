class MatchPointsPresenter
  def initialize(match)
    @match = match
    @games = match.games.for_scores.filter(&:finished?)

    @cumulative_points = cumulative_points
  end

  def props
    {
      player_names: @match.players.map(&:name),
      games: games,
    }
  end

  private

  def games
    @games.each_with_index.map do |game, index|
      Points::GamePointsPresenter.new(game, @cumulative_points[index]).props
    end
  end

  def cumulative_points
    rp = raw_points

    rp.each_with_index.map do |rp_row, row_index|
      rp_row.each_with_index.map do |point, point_index|
        cumulative_rows = rp[0..row_index]
        cumulative_rows.sum { |cr| cr[point_index] || 0 }
      end
    end
  end

  def raw_points
    @games.map do |game|
      @match.players.map do |player|
        game.game_players.find_by(player_id: player.id)&.game_points || 0
      end
    end
  end
end
