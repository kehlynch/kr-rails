class HandPresenter
  def initialize(game, active_player)
    @game = game
    @active_player = active_player
  end

  def props_for_bids
    {
      id: id('pick-bids'),
      hand: sorted_hand_with(:hand_props_for_pick_talon),
    }
  end

  def props_for_pick_talon
    {
      id: id('pick-talon'),
      hand: sorted_hand_with(:hand_props_for_pick_talon),
    }
  end

  def resolve_talon_props
    {
      id: id('resolve-talon'),
      hand: sorted_hand_with(:hand_props_for_resolve_talon),
    }
  end

  def props_for_trick(trick, index)
    {
      id: id("trick-#{index}"),
      hand: hand_props_for_trick(trick, index)
    }
  end

  def props_for_kings
    {
      id: id('king'),
      hand: sorted_hand_with(:hand_props_for_kings),
    }
  end

  def props_for_finished
    {
      id: id('finished'),
      hand: finished_hand_props,
    }
  end

  private

  def id(prefix)
    "js-#{prefix}-hand"
  end

  def finished_hand_props
    sorted_cards(@active_player.original_hand_cards).map do |c|
      CardPresenter.new(c, @active_player).hand_props_for_finished
    end
  end

  def hand_props_for_trick(trick, trick_index)
    ltcs = LegalTrickCardService.new(@active_player, trick, @game.won_bid)
    sorted_cards.map do |card|
      legal = ltcs.legal?(card)
      CardPresenter
        .new(card, @active_player)
        .hand_props_for_trick(trick, trick_index, legal)
    end
  end

  def sorted_hand_with(props_method, *args)
    sorted_cards.map do |c|
      CardPresenter.new(c, @active_player).public_send(props_method, *args)
    end
  end

  def sorted_cards(cards=nil)
    cards ||= @active_player.hand_cards
    display_order = ['trump', 'heart', 'spade', 'diamond', 'club']
    cards.sort_by do |c|
      [display_order.index(c.suit), -c.value]
    end
  end
end
