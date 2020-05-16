class TrickPresenter
  attr_reader :trick, :trick_index

  def initialize(game, active_player, index, trick, visible)
    @game = game
    @active_player = active_player
    @index = index
    @trick = trick
    @visible = visible
  end

  def props
    {
      index: @index,
      visible: @visible,
      cards: cards_props,
      instruction: InstructionPresenter.new(instruction, Stage::TRICK, @index).props,
      hand: HandPresenter.new(@game, @active_player).props_for_trick(@trick, @index)
    }
  end

  private

  def cards_props
    return [] unless @trick

    @trick.cards.map do |card|
      CardPresenter.new(card, @active_player).props_for_played(trick)
    end
  end

  def instruction
    return finished_instruction if @trick.finished?

    return nil unless @trick.next_player

    return "play a card" if @trick.next_player&.id == @active_player.id

    "Waiting for #{trick.next_player.name} to play a card"
  end

  def finished_instruction
    "#{@trick.winning_player.name} wins trick. Click to continue."
  end
end
