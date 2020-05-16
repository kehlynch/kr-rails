class Bids::BidsBasePresenter
  def initialize(game, active_player, visible_stage)
    @game = game
    @active_player = active_player
    @visible_stage = visible_stage
  end

  def props
    {
      stage: stage,
      visible: visible,
      finished: finished?,
      finished_message: finished_message,
      bid_picker: bid_picker_props,
      instruction: instruction_props,
      players: players_props,
      hand: hand_props
    }
  end
  
  def bid_picker_props
    Bids::BidPickerPresenter.new(biddable_props, stage, bid_picker_visible?).props
  end

  def instruction_props
    InstructionPresenter.new(instruction, stage).props
  end

  def biddable_props
    raise NotImplementedError
  end

  def stage
    raise NotImplementedError
  end

  def visible
    @visible_stage == stage
  end

  def bid_picker_visible?
    @game.next_player&.id == @active_player.id && !finished?
  end

  def finished?
    raise NotImplementedError
  end

  def finished_message
    raise NotImplementedError
  end

  def instruction
    raise NotImplementedError
  end

  def valid_bids_props
    raise NotImplementedError
  end

  def players_props
    raise NotImplementedError
  end

  def hand_props
    raise NotImplementedError
  end
end
