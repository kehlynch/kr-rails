module GameHelper
  def winner_icon(player)
    return "" unless player.winner?
    return "⭐️"
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
  
  def announcement_button(slug, name)
    button_tag(
      name,
      alt: name,
      type: 'button',
      class: 'btn btn-outline-dark js-submit-game',
      onclick: "toggleAnnouncement(#{slug})"
    )
  end

  def talon_half(cards, index, game, stage)
    is_pickable = game.declarer_human? && stage.action == 'pick_talon'
    pickable_class = is_pickable ? "pickable" : ""
    onclick = game.declarer_human? ? "submitGame(talon_#{index})" : ""

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
    ['resolve_talon', 'resolve_whole_talon'].include?(game.stage) && game.declarer_human?
  end

  def hand_card_pickable?(game, action)
    human_resolve_talon?(game) || action == 'play_card'
  end

  def hand_card_button(card, game, action)
    pickable = hand_card_pickable?(game, action)
    pickable_class = pickable ? 'pickable' : ''
    illegal_class = pickable && !card.legal? ? 'illegal' : ''
    classes = "js-submit-game #{pickable_class} #{illegal_class}"
    onclick = pickable && card.legal? && card_action(card.slug, action)
    card_tag(card.slug, classes: classes, onclick: onclick)
  end

  def king_card_button(card_slug, hand, game)
    own_king = hand.find {|c| c.slug == card_slug}.nil? ? '' : 'own_king'
    pickable = game.declarer_human? ? 'pickable' : ''
    classes = "js-submit-game #{pickable} #{own_king}"
    onclick = card_action(card_slug, 'pick_king')
    card_tag(card_slug, classes: classes, onclick: onclick)
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

  private

  def card_action(card_slug, action)
    checkbox_id = "#{action}_#{card_slug}"
    function =
      if ['play_card', 'pick_king'].include?(action)
        'submitGame'
      elsif ['resolve_talon', 'resolve_whole_talon'].include?(action)
        'toggleCard'
      end
    "#{function}(#{checkbox_id})"
  end
end
