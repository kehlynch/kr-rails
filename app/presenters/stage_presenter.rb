class StagePresenter
  def initialize(game)
    @game = game
  end

  def message
    MessagePresenter.new(@game, action).message
  end

  def action
    p '*** @game.current_trick_finished?'
    p  @game.current_trick_finished?
    return 'next_trick' if @game.stage == 'play_card' && @game.current_trick_finished?

    @game.stage
  end

  def show_talon?
    action == 'pick_talon' || action == 'pick_whole_talon' || (action == 'resolve_talon' && !@game.declarer_human?)
  end
end
