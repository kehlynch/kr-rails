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
      classes: classlist(
        forehand: @player.forehand?,
        winner: winner?,
        declarer: @game&.declarer&.id == @player.id
      ).join(' ')
    }
  end

  private

  def id
    "js-points-#{@game.id}-#{@player.id}"
  end

  def winner?
    winning_team = @game.won_bid&.off ? GamePlayer::DEFENDERS : GamePlayer::DECLARERS

    @player.team == winning_team
  end

  def classlist(**args)
    args.select{ |_k, v| v }.keys
  end
end
