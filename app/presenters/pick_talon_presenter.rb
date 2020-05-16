class PickTalonPresenter
  def initialize(game, active_player, visible_stage)
    @game = game
    @talon = @game.talon
    @talon_picked = @game.talon_picked
    @declarer = @game.declarer
    @active_player = active_player
    @visible_stage = visible_stage
  end

  def props
    {
      stage: Stage::PICK_TALON,
      visible: Stage::PICK_TALON == @visible_stage,
      halves: @talon.each_with_index.map { |h, i| half_props(h, i) },
      finished: finished?,
      instruction: InstructionPresenter.new(instruction, Stage::PICK_TALON).props,
      hand: HandPresenter.new(@game, @active_player).props_for_pick_talon
    }
  end

  private

  def finished?
    @talon_picked.present?
  end

  def instruction
    return "can't find a declarer! (this should be hidden)" unless @declarer.present?

    return finished_instruction if finished?

    return active_instruction if @active_player.declarer?

    return "waiting for #{@declarer&.name} to pick talon"
  end

  def finished_instruction
    # TODO this is workaround for what we set on game record - 0 or 1 refer to indexes of talon halves. 3 means whole talon. Make this nicer
    if @talon_picked == 3
      "#{@declarer&.name} takes the whole talon. Click to continue."
    else
      "#{@declarer&.name} picks #{ActiveSupport::Inflector.ordinalize(@talon_picked + 1)} half of talon. Click to continue."
    end
  end

  def active_instruction
    return 'pick half of the talon' if @game.bids.talon_cards_to_pick == 3

    'click to take the whole talon'
  end

  def talon_pickable?
    @active_player.declarer?
  end

  def half_props(cards, index)
    {
      pickable: talon_pickable?,
      picked: @talon_picked == index,
      index: index,
      cards: cards.map { |c| CardPresenter.new(c, @active_player).props_for_pick_talon }
    }
  end
end
