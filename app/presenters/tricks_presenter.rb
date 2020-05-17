class TricksPresenter
  attr_reader :tricks

  delegate(
    :[],
    :current_trick_finished?,
    :length,
    to: :tricks
  )

  def initialize(game, active_player, visible_stage, visible_trick_index)
    @game = game
    @tricks = game.tricks
    @active_player = active_player
    @visible_stage = visible_stage
    @visible_trick_index = visible_trick_index
  end

  def props
    {
      stage: Stage::TRICK,
      visible: @visible_stage == Stage::TRICK,
      tricks: tricks_props,
      playable_trick_index: @tricks.playable_trick_index,
      finished: @game.tricks.finished?
    }
  end

  private

  def tricks_props
    @tricks.each_with_index.map do |trick, index|
      TrickPresenter.new(
        @game,
        @active_player,
        index,
        trick,
        index == @visible_trick_index
      ).props
    end
  end
end
