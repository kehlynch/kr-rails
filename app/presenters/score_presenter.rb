class ScorePresenter
  def initialize(player, game, _active_player)
    @player = player
    @game = game
    # @active_player = active_player
  end

  def props
    won_tricks_count =
      @player
      .won_tricks
      .map(&:trick_index)
      .size

    {
      id: "js-score-#{@player.id}",
      name: @player.name,
      won_tricks_count: won_tricks_count,
      points: @player.card_points,
      team_points: team_points,
      game_points: @player.game_points,
      winner: @player.winner?
    }
  end

  private

  def winner?
    @game.won_bid&.off || @player.team == GamePlayer::DEFENDERS
  end

  def team_points
    case @player.team
    when GamePlayer::DECLARERS
      @game.declarers.map(&:card_points).compact.sum
    when GamePlayer::DEFENDERS
      @game.defenders.map(&:card_points).compact.sum
    else
      @player.card_points
    end
  end
end
