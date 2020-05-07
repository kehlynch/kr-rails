class TricksPresenter
  attr_reader :tricks

  delegate(
    :[],
    :current_trick_finished?,
    :each_with_index,
    :length,
    to: :tricks
  )

  def initialize(game, active_player, visible_stage)
    @game = game
    @tricks = game.tricks
    @active_player = active_player
    @visible_stage = visible_stage
  end

  def props
    {
      visible: @visible_stage == Stage::TRICK,
      visible_trick_index: visible_trick_index,
      tricks: tricks_props
    }
  end

  private

  def tricks_props
    (0..11).map do |trick_index|
      trick = @tricks[trick_index]
      trick_props(trick, trick_index)
    end
  end

  def trick_props(trick, index)
    {
      index: index,
      visible: visible_trick_index == index,
      cards: cards_props(trick)
    }
  end

  def cards_props(trick)
    return [] unless trick

    trick.cards.map do |card|
      CardPresenter.new(card, @active_player).trick_props(trick)
    end
  end

  def visible_trick_index
    show_penultimate_trick? ? @tricks.playable_trick_index - 1 : tricks.playable_trick_index
  end

  def show_penultimate_trick?
    return false unless @visible_stage == Stage::TRICK

    return false if @active_player.played_in_current_trick?
    
    return false if @game.tricks.current_trick&.finished?

    return false if @game.tricks.count < 2

    return true
  end
end
