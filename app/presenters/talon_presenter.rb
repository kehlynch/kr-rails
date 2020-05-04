class TalonPresenter
  def initialize(talon, active_player, declarer, talon_picked, visible_stage)
    @talon = talon
    @active_player = active_player
    @declarer = declarer
    @talon_picked = talon_picked
    @visible_stage = visible_stage
  end

  def props
    {
      visible: Stage::talon_stage?(@visible_stage),
      halves: @talon.each_with_index.map { |h, i| half_props(h, i) }
    }
  end

  private

  def half_props(cards, index)
    {
      pickable: Stage.talon_stage?(@visible_stage) && @active_player.declarer?,
      picked: @talon_picked == index,
      index: index,
      cards: cards.map { |c| CardPresenter.new(c, @active_player).talon_props(@declarer, @visible_stage) }
    }
  end
end
