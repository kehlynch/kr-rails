class Points::PlayerPointsPresenter
  def initialize(player, game, points, id)
    @player = player
    @game = game
    @points = points
    @id = id
  end

  def props
    {
      id: @id,
      points: @points,
      classes: classlist(
        forehand: @player&.forehand?,
        winner: winner?,
        declarer: @game&.declarer&.id == @player&.id,
        out: @player.nil?
      ).join(' ')
    }
  end

  private

  def winner?
    winning_team = @game.won_bid&.off ? GamePlayer::DEFENDERS : GamePlayer::DECLARERS

    @player&.team == winning_team
  end

  def classlist(**args)
    args.select{ |_k, v| v }.keys
  end
end
