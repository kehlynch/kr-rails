class Points::GamePointsPresenter
  def initialize(game, cumulative_points)
    @game = game
    @cumulative_points = cumulative_points
  end

  def props
    {
      shorthands: Points::GamePointsShorthandsPresenter.new(@game).props,
      players: players_props
    }
  end

  def players_props
    @game.game_players.each_with_index.map do |player, i|
      Points::PlayerPointsPresenter.new(player, @game, @cumulative_points[i]).props
    end
  end
end
