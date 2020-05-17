class CardPresenter
  def initialize(card, active_player)
    @card = card
    @active_player = active_player
  end

  def props_for_call_king
    input_id = id(Stage::KING)
    {
      slug: @card.slug,
      stage: Stage::KING,
      classes: classlist(
        own_king: @card.player&.id == @active_player.id,
        pickable: @active_player.declarer? && @card.game.king.blank?,
        picked: @card.game.king == @card.slug
      ).join(' '),
      input_id: id(Stage::KING),
      onclick: @active_player.declarer? && !@card.game.king.blank? && "submitGame(#{input_id})"
    }
  end


  def hand_props_for_bids
    {
      slug: @card.slug,
      stage: Stage::BID,
      pickable: false,
      illegal: nil,
      onclick: nil
    }
  end


  def props_for_pick_talon
    {
      stage: Stage::PICK_TALON,
      slug: @card.slug,
    }
  end

  def hand_props_for_resolve_talon
    id = id(Stage::RESOLVE_TALON);
    {
      slug: @card.slug,
      stage: Stage::RESOLVE_TALON,
      pickable: @active_player.declarer?,
      illegal: @active_player.declarer? && !@card.simple_legal_putdown?,
      input_id: id,
      onclick: @active_player.declarer? && "toggleCard('#{id}', #{@card.game.bids.talon_cards_to_pick})",
    }
  end

  def hand_props_for_pick_talon
    {
      slug: @card.slug,
      stage: Stage::PICK_TALON,
      pickable: false,
      illegal: nil,
      onclick: nil
    }
  end

  def hand_props_for_kings
    {
      slug: @card.slug,
      stage: Stage::BID,
      pickable: false,
      illegal: nil,
      onclick: nil
    }
  end

  def props_for_played(trick)
    {
      slug: @card.slug,
      compass: compass,
      landscape: ['east', 'west'].include?(compass),
      won: trick.won_card&.slug == @card.slug,
      input_id: "played_#{trick.trick_index}_#{id(Stage::TRICK)}",
      trick_index: trick.trick_index
    }
  end

  def hand_props_for_trick(trick, trick_index)
    id = "trick#{trick_index}_#{id(Stage::TRICK)}"
    active_player_next = trick&.next_player&.id == @active_player.id
    {
      slug: @card.slug,
      stage: Stage::TRICK,
      pickable: active_player_next,
      illegal: active_player_next &&! @card.legal?,
      input_id: id,
      onclick: active_player_next && @card.legal? && "playCard(#{id})",
    }
  end

  def hand_props_for_finished
    {
      slug: @card.slug,
      stage: Stage::FINISHED,
      pickable: false,
      illegal: nil,
      onclick: nil
    }
  end

  private

  def id(stage)
    "#{stage}_#{@card.slug}"
  end

  def compass
    index = (@card.player.position - @active_player.position) % 4
    ['south', 'east', 'north', 'west'][index]
  end

  def classlist(**args)
    args.select{ |_k, v| v }.keys
  end
end
