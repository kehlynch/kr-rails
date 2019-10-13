# frozen_string_literal: true

module GameHelper
  def hand_card_button(card, runner)
    pickable = [:play_card, :resolve_talon].include?(runner.stage) ? 'pickable' : ''
    illegal = card.legal ? '' : 'illegal'
    classes = "js-submit-game #{pickable} #{illegal}"
    onclick = card_action(card, runner)
    card_button(card.slug, classes, onclick)
  end

  def card_action(card, runner)
    checkbox_id = "play_card_#{card.slug}"
    if runner.stage == :play_card
      card.legal && "submitGame(#{checkbox_id})"
    elsif runner.stage == :resolve_talon
      card.legal && "toggleCard(#{checkbox_id})"
    end
  end

  def king_card_button(card_slug, hand)
    own_king = hand.include?(card_slug) ? 'own_king' : ''
    classes = "js-submit-game pickable #{own_king}"
    checkbox_id = "pick_king_#{card_slug}"
    onclick = "submitGame(#{checkbox_id})"
    card_button(card_slug, classes, onclick)
  end

  def talon_button(index)
    content_tag(
      :div,
      alt: "talon #{index}",
      class: 'row pl=4 pr-4 justify-content-center js-submit-game',
      onclick: "submitGame(talon_#{index})"
    )
  end

  def contract_button(contract, label)
    button_tag(
      label,
      alt: contract,
      class: 'contract-button js-submit-game',
      onclick: "submitGame(#{contract})"
    )
  end

  def layout_trick(cards)
    p '*** layout_trick ***'
    p cards
    return {} unless cards

    {
      n: find_player_card(cards, 0),
      w: find_player_card(cards, 1),
      s: find_player_card(cards, 2),
      e: find_player_card(cards, 3)
    }
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

  def card_button(card_slug, classes = '', onclick = nil)
    image_tag(
      "#{card_slug}.jpg",
      alt: card_slug,
      class: "card #{classes}",
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
      lead: runner.lead_player_id == id,
      points: runner.players[id].points,
      winner: runner.winners.include?(id)
    }
  end
end
