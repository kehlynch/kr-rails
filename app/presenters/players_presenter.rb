class PlayersPresenter
  def initialize(game, active_player, visible_stage)
    @game = game
    @active_player = active_player
    @visible_stage = visible_stage
  end

  def props
    remarks = Remarks.remarks_for(@game)

    @game.players.map do |player|
      PlayerPresenter.new(player, @game, @visible_stage, @active_player).props(remarks[player.id])
    end
  end
end
