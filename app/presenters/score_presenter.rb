class ScorePresenter
  def initialize(player, game, _active_player)
    @player = player
    @game = game
    # @active_player = active_player
  end

  def props
    {
      id: "js-score-#{@player.id}",
      name: @player.name,
      won_tricks_count: @player.won_tricks.count,
      points: @player.card_points,
      team_points: @player.team_members.map(&:card_points).sum,
      game_points: @player.game_points,
      winner: @player.winner?
    }
  end

  private

  def winner?
    @game.won_bid&.off || @player.team == GamePlayer::DEFENDERS
  end
end
