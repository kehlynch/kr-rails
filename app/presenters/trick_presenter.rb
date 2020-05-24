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

  attr_reader :game

  delegate(
    :next_player,
    to: :game
  )

  def cards_props
    return [] unless @trick

    @trick.cards.map do |card|
      CardPresenter.new(card, @active_player).props_for_played(trick)
    end
  end

  def instruction
    return game_finished_instruction if @game.tricks.finished?

    return finished_instruction if @trick.finished?

    return "play a card" if next_player&.id == @active_player.id

    "Waiting for #{next_player.name} to play a card"
  end

  def finished_instruction
    "#{@trick.winning_player.name} wins trick. Click to continue."
  end

  def game_finished_instruction
    "#{@trick.winning_player.name} wins last trick. Click for scores."
  end
end
