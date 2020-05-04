class CardPresenter
  def initialize(card, active_player)
    @card = card
    @active_player = active_player
  end

  def trick_props(trick)
    {
      slug: @card.slug,
      compass: compass,
      landscape: ['east', 'west'].include?(compass),
      won: trick.won_card&.slug == @card.slug
    }
  end

  def hand_props(stage)
    {
      slug: @card.slug,
      stage: stage,
      pickable: pickable?(stage),
      legal: @card.legal?,
      onclick: onclick(stage)
    }
  end

  private

  # TODO attach listeners from the JS instead?
  def onclick(stage)
    return nil unless pickable?(stage)

    checkbox_id = "#{stage}_#{@card.slug}"

    return "playCard(#{checkbox_id})" if Stage::TRICK == stage

    return "toggleCard(#{checkbox_id})"
  end

  def checkbox_id(stage)

  end

  def compass
    index = (@card.player.position - active_player.position) % 4
    ['south', 'east', 'north', 'west'][index]
  end

  def pickable?(stage)
    return false unless [Stage::TRICK, Stage::RESOLVE_TALON, Stage::RESOLVE_WHOLE_TALON].include?(stage)

    @game.next_player&.id == @active_player.id
  end
end
