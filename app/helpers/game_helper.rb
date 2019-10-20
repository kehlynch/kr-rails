module GameHelper
  def winner_icon(player)
    return "" unless player.winner?
    return "⭐️"
  end
  
  def talon_half(cards, index, game)
    pickable_class = @game.human_declarer? ? "pickable" : ""
    onclick = @game.human_declarer? ? "submitGame(talon_#{index})" : ""

    picked_class = @game.talon_picked == index ? "picked" : ""

    content_tag(
      :div,
      onclick: onclick,
      class: "talon-half-container #{pickable_class} #{picked_class}"
    ) do
      render('talon_half', cards: cards, index: index)
    end
  end

  def human_resolve_talon?(game)
    game.stage == 'resolve_talon' && game.human_declarer?
  end

  def hand_card_button(card, game)
    pickable = human_resolve_talon?(game) || game.stage == 'play_card'
    pickable_class = pickable ? 'pickable' : ''
    illegal_class = card.legal ? '' : 'illegal'
    classes = "js-submit-game #{pickable_class} #{illegal_class}"
    onclick = card_action(card, game)
    card_tag(card.slug, classes: classes, onclick: onclick)
  end

  def card_action(card, game)
    if game.stage == 'play_card'
      checkbox_id = "play_card_#{card.slug}"
      card.legal && "submitGame(#{checkbox_id})"
    elsif game.stage == 'resolve_talon'
      checkbox_id = "resolve_talon_#{card.slug}"
      card.legal && "toggleCard(#{checkbox_id})"
    end
  end

  def king_card_button(card_slug, hand)
    own_king = hand.find {|c| c.slug == card_slug}.nil? ? '' : 'own_king'
    classes = "js-submit-game pickable #{own_king}"
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

  def layout_players(game)
    {
      n: game.players[0],
      w: game.players[1],
      s: game.players[2],
      e: game.players[3]
    }
  end

  def rufer_options
    {
      trischaken: 'Trischaken',
      sechserdreier: 'Sechserdreier',
      rufer: 'Call a king'
    }
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

  def find_player_card(cards, position)
    cards.find { |c| c.player.position == position }
  end

  def player_info(id, game)
    trick_count = game.tricks.won_tricks(id).length
    
    {
      trick_count: trick_count,
      lead: game.lead_player_id == id,
      points: game.players[id].points,
      winner: game.winners.include?(id)
    }
  end
end
