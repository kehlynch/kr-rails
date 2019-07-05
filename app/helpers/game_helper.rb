# frozen_string_literal: true

module GameHelper
  def hand_card_button(card, pickable)
    active = pickable ? 'pickable' : ''
    illegal = card.legal ? '' : 'illegal'
    classes = "js-submit-game #{active} #{illegal}"
    checkbox_id = "play_card_#{card.slug}"
    onclick = pickable && card.legal && "submitGame(#{checkbox_id})"
    card_button(card.slug, classes, onclick)
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
    return {} unless cards

    {
      n: find_player_card(cards, 0),
      w: find_player_card(cards, 1),
      s: find_player_card(cards, 2),
      e: find_player_card(cards, 3)
    }
  end

  def layout_players(runner)
    {
      n: player_info(0, runner),
      w: player_info(1, runner),
      s: player_info(2, runner),
      e: player_info(3, runner)
    }
  end

  def rufer_options
    {
      trischaken: 'Trischaken',
      sechserdreier: 'Sechserdreier',
      rufer: 'Call a king'
    }
  end

  private

  def card_button(card_slug, classes = '', onclick = nil)
    image_tag(
      "#{card_slug}.jpg",
      alt: card_slug,
      class: "card #{classes}",
      onclick: onclick
    )
  end

  def find_player_card(cards, id)
    cards.find { |c| c.player_id == id }
  end

  def player_info(id, runner)
    # player = players.find { |p| p.id == id }
    trick_count = runner.tricks.select(&:finished).select do |t|
      t.winning_player_id == id
    end.length
    {
      trick_count: trick_count,
      lead: runner.lead_player_id == id,
      points: runner.players[id].points
    }
  end
end
