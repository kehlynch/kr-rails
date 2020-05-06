class Points::PlayerPointsPresenter
  def initialize(player, game, points)
    @player = player
    @game = game
    @points = points
  end

  def props
    {
      points: @points,
      forehand: @player.forehand?,
      winner: @game.winners.map(&:id).include?(@player.id),
      declarer: @game.declarer.id == player.id
    }
  end
end
