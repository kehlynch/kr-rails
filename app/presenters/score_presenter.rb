class ScorePresenter
  def initialize(player, game, active_player)
    @player = player
    @game = game
    @active_player = active_player
  end

  def props
    {
      id: "js-score-#{@player.id}",
      name: @player.name,
      won_tricks_count: @player.won_tricks.count,
      points: @player.points,
      team_points: @player.team_points,
      game_points: @player.game_points,
      winner: @player.winner?
    }
  end
end
