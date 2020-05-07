class InstructionPresenter
  def initialize(game, active_player, visible_stage)
    @game = game
    @active_player = active_player
    @visible_stage = visible_stage
  end

  def props
    {
      instruction: instruction(@game.next_player.id == @active_player.id)
    }
  end

  private

  def instruction(active)
    active ? active_instruction : passive_instruction
  end

  def passive_instruction
    action_description = {
      Stage::BID => "bid",
      Stage::KING => "pick a king",
      Stage::PICK_TALON => 'pick half of the talon.',
      Stage::PICK_WHOLE_TALON => 'take the whole talon.',
      Stage::RESOLVE_TALON => 'put down 3 cards',
      Stage::RESOLVE_WHOLE_TALON => 'put down 6 cards',
      Stage::ANNOUNCEMENT => 'make an announcement',
      Stage::TRICK => 'play a card'}[@visible_stage]

    "waiting for #{@game.next_player.name} to #{action_description}"
  end

  def active_instruction
    {
      Stage::BID => 'Make a bid.',
      Stage::KING => 'Pick a king.',
      Stage::PICK_TALON => 'Pick half of the talon.',
      Stage::PICK_WHOLE_TALON => 'Click to take whole talon.',
      Stage::RESOLVE_TALON => 'Pick 3 cards to put down',
      Stage::RESOLVE_WHOLE_TALON => 'Pick 6 cards to put down',
      Stage::ANNOUNCEMENT => 'Make an announcement',
      Stage::TRICK => show_penultimate_trick? ? 'click for next trick' : 'Play a card'
    }[@visible_stage]
  end

  # TODO duplicated in app/presenters/tricks_presenter. Maybe have the sections responsible for their own instructions?
  def show_penultimate_trick?
    return false unless @visible_stage == Stage::TRICK

    return false if @active_player.played_in_current_trick?
    
    return false if @game.tricks.current_trick&.finished?

    return false if @game.tricks.count < 2

    return true
  end
end
