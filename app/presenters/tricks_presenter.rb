class TricksPresenter
  def initialize(game, active_player, visible_stage, visible_trick_index)
    @game = game
    @tricks = game.tricks
    @active_player = active_player
    @visible_stage = visible_stage
    @visible_trick_index = visible_trick_index
    @playable_trick_index = @game.playable_trick_index
  end

  def props
    {
      stage: Stage::TRICK,
      visible: @visible_stage == Stage::TRICK,
      tricks: tricks_props,
      playable_trick_index: @playable_trick_index,
      finished: @game.tricks_finished?
    }
  end

  private

  def tricks_props
    @tricks.map do |trick|
      TrickPresenter.new(
        @game,
        @active_player,
        trick,
        trick.trick_index == @visible_trick_index
      ).props
    end
  end
end
