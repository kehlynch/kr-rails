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
    @game.match.players.each_with_index.map do |player, i|
      Points::PlayerPointsPresenter.new(
        @game.game_players.find_by(player_id: player.id),
        @game,
        @cumulative_points[i],
        "js-points-#{@game.id}-#{i}"
      ).props
    end
  end
end
