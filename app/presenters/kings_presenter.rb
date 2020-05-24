class KingsPresenter
  def initialize(game, active_player, visible_stage)
    @game = game
    @visible_stage = visible_stage
    @active_player = active_player
  end

  def props
    {
      stage: Stage::KING,
      visible: @visible_stage == Stage::KING,
      kings: kings_props,
      instruction: InstructionPresenter.new(instruction, Stage::KING).props,
      hand: HandPresenter.new(@game, @active_player).props_for_kings,
      finished: @game.king.present?
    }
  end

  private

  def kings_props
    @game.kings.map do |king|
      CardPresenter.new(king, @active_player).props_for_call_king
    end
  end

  def instruction
    return "" unless @game.stages.include?(Stage::KING)

    return "#{@game.declarer&.name} picks #{king_name(@game.king)}. Click to continue" if @game.king.present?

    return 'pick a King' if @game.next_player&.id == @active_player.id

    "waiting for #{@game.next_player.name} to pick a King"
  end

  def king_name(slug)
    "King of #{slug.split('_')[0].titleize}s"
  end
end
