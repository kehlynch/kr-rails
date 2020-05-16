class ResolveTalonPresenter
  def initialize(game, active_player, visible_stage)
    @game = game
    @active_player = active_player
    @visible_stage = visible_stage
  end

  def props
    {
      stage: Stage::RESOLVE_TALON,
      visible: @visible_stage == Stage::RESOLVE_TALON,
      resolvable: !@game.talon_resolved && @active_player.declarer?,
      hand: HandPresenter.new(@game, @active_player).resolve_talon_props,
      instruction: InstructionPresenter.new(instruction, Stage::RESOLVE_TALON).props,
      finished: @game.talon_resolved
    }
  end

  private

  def instruction
    return finished_instruction if @game.talon_resolved

    return "select #{@game.bids.talon_cards_to_pick} cards to put down" if @active_player.declarer?

    "waiting for #{@game.declarer&.name} to put down #{@game.bids.talon_cards_to_pick} cards"
  end

  def finished_instruction
    "#{@game.declarer&.name} puts down #{@game.bids.talon_cards_to_pick} cards. Click to continue"
  end
end
