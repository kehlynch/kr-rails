module GameHelper
  def winner_icon(player)
    return "" unless player.winner?
    return "⭐️"
  end
  
  def talon_half(cards, index, game, stage)
    is_pickable = game.human_declarer? && stage == 'pick_talon'
    pickable_class = is_pickable ? "pickable" : ""
    onclick = game.human_declarer? ? "submitGame(talon_#{index})" : ""

    picked_class = game.talon_picked == index ? "picked" : ""

    content_tag(
      :div,
      onclick: onclick,
      class: "talon-half-container #{pickable_class} #{picked_class}"
    ) do
      render('talon_half', cards: cards, index: index)
    end
  end

  def human_resolve_talon?(game)
    ['resolve_talon', 'resolve_whole_talon'].include?(game.stage) && game.human_declarer?
  end

  def hand_card_button(card, game, action)
    pickable = human_resolve_talon?(game) || action == 'play_card'
    pickable_class = pickable ? 'pickable' : ''
    illegal_class = pickable && !card.legal? ? 'illegal' : ''
    classes = "js-submit-game #{pickable_class} #{illegal_class}"
    onclick = card_action(card, action)
    card_tag(card.slug, classes: classes, onclick: onclick)
  end

  def card_action(card, action)
    checkbox_id = "#{action}_#{card.slug}"
    function = action == 'play_card' ? 'submitGame' : 'toggleCard'
    card.legal? && "#{function}(#{checkbox_id})"
  end

  def king_card_button(card_slug, hand, game)
    own_king = hand.find {|c| c.slug == card_slug}.nil? ? '' : 'own_king'
    pickable = game.human_declarer? ? 'pickable' : ''
    classes = "js-submit-game #{pickable} #{own_king}"
    checkbox_id = "pick_king_#{card_slug}"
    onclick = "submitGame(#{checkbox_id})"
    card_tag(card_slug, classes: classes, onclick: onclick)
  end

  def bid_button(slug, name)
    button_tag(
      name,
      alt: name,
      type: 'button',
      class: 'btn btn-outline-dark js-submit-game',
      onclick: "submitGame(#{slug})"
    )
  end

  def card_tag(card_slug, classes: classes = '', onclick: nil, landscape: false)
    filename = landscape ? "landscape_#{card_slug}.jpg" : "#{card_slug}.jpg"
    image_tag(
      filename,
      alt: card_slug,
      class: "kr-card #{classes}",
      onclick: onclick
    )
  end
end
