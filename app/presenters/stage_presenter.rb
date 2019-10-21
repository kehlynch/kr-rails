class StagePresenter
  def initialize(game_id)
    @game_id = game_id
    @game = Game.find(game_id)
    @tricks = Tricks.new(game_id)
  end

  def message
    MessagePresenter.new(@game_id, action).message
  end

  def action
    return 'next_trick' if @game.stage == 'play_card' && @tricks.current_trick_finished?

    @game.stage
  end

  def show_talon?
    action == 'pick_talon' || action == 'pick_whole_talon' || (action == 'resolve_talon' && !@game.declarer_human?)
  end
end
