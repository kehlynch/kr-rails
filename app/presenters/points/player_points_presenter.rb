class Points::PlayerPointsPresenter
  def initialize(player, game, points)
    @player = player
    @game = game
    @points = points
  end

  def props
    {
      id: id,
      points: @points,
      forehand: @player.forehand?,
      winner: winner?,
      declarer: @game&.declarer&.id == @player.id
    }
  end

  private

  def id
    "js-points-#{@game.id}-#{@player.id}"
  end

  def winner?
    @game.won_bid&.off || @player.team == GamePlayer::DEFENDERS
  end
end
