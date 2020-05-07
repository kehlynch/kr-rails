class HandPresenter
  def initialize(game, active_player, visible_stage)
    @game = game
    @active_player = active_player
    @visible_stage = visible_stage
  end

  def props
    display_order = ['trump', 'heart', 'spade', 'diamond', 'club']
    @active_player.hand.sort_by do |c|
      [display_order.index(c.suit), -c.value]
    end.map do |c|
      CardPresenter.new(c, @active_player).hand_props(@visible_stage)
    end
  end
end
