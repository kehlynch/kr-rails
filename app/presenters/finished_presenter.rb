class FinishedPresenter
  include Rails.application.routes.url_helpers  

  def initialize(game, active_player, visible_stage)
    @game = game
    @active_player = active_player
    @visible_stage = visible_stage
  end

  def props
    {
      stage: Stage::FINISHED,
      visible: @visible_stage == Stage::FINISHED,
      instruction: InstructionPresenter.new(instruction, Stage::FINISHED).props,
      hand: HandPresenter.new(@game, @active_player).props_for_finished,
      next_hand_path: next_match_player_game_path(@game.match_id, @active_player.player_id, @game.id),
      points: Points::PointsPresenter.new(@game.match, @active_player).props,
      scores: ScoresPresenter.new(@game, @active_player).props
    }
  end
  
  private

  def instruction
    "Hand finished!"
  end
end