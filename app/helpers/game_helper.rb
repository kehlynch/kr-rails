module GameHelper
  def winner_icon(player)
    return "" unless player.winner?

    return "⭐️"
  end

  def player_compass_position(player_pos, active_player_pos)
    index = (player_pos - active_player_pos) % 4
    ['south', 'east', 'north', 'west'][index]
  end

  def bid_button(slug, name, type)
    button_tag(
      name,
      alt: name,
      type: 'button',
      class: 'btn btn-outline-dark',
      onclick: "submitBid('#{slug}', '#{type}')"
    )
  end

  def talon_half(cards, index, game, action)
    pickable_class = game.talon_pickable? ? "pickable" : ""
    onclick = game.talon_pickable? ? "submitGame(talon_#{index})" : ""

    picked_class = game.talon_picked == index ? "picked" : ""

    content_tag(
      :div,
      onclick: onclick,
      class: "talon-half-container #{pickable_class} #{picked_class}",
      id: "js-talon-half-#{index}"
    ) do
      render('talon_half', cards: cards, index: index)
    end
  end

  def human_resolve_talon?(game, player)
    ['resolve_talon', 'resolve_whole_talon'].include?(game.visible_stage) && game.declarer.id == player.id
  end

  def hand_card_pickable?(game, player, action)
    human_resolve_talon?(game, player) || (action == 'play_card' && game.next_player.id == player.id)
  end

  def hand_card_button(card, game, player, action)
    pickable = hand_card_pickable?(game, player, action)
    pickable_class = pickable ? 'pickable' : ''
    illegal_class = pickable && !card.legal? ? 'illegal' : ''
    classes = "#{pickable_class} #{illegal_class}"
    onclick = pickable && card.legal? && card_action(card.slug, action, "hand_#{card.slug}")
    card_tag(card.slug, classes: classes, onclick: onclick)
  end

  def king_card_button(card_slug, player, game)
    own_king = player.hand.find { |c| c.slug == card_slug }.nil? ? '' : 'own_king'
    pickable = player.declarer? ? 'pickable' : ''

    picked = game.king == card_slug ? 'selected' : ''
    classes = "#{pickable} #{own_king} #{picked}"
    onclick = card_action(card_slug, 'pick_king')
    card_tag(card_slug, classes: classes, onclick: onclick)
  end

  def card_tag(card_slug, classes: '', onclick: nil, landscape: false)
    filename = landscape ? "landscape_#{card_slug}.jpg" : "#{card_slug}.jpg"
    image_tag(
      filename,
      alt: card_slug,
      class: "kr-card #{classes}",
      onclick: onclick
    )
  end

  private

  def card_action(card_slug, action, checkbox_id = nil)
    checkbox_id ||= "#{action}_#{card_slug}"
    function =
      if action == 'play_card'
        'playCard'
      elsif action == 'pick_king'
        'submitGame'
      elsif ['resolve_talon', 'resolve_whole_talon'].include?(action)
        'toggleCard'
      end
    "#{function}(#{checkbox_id})"
  end
end
