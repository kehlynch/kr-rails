# frozen_string_literal: true

module GameHelper
  def card_button(card)
    image_tag(
      "#{card.slug}.jpg",
      alt: card.slug,
      class: "card js-submit-game #{card.legal ? '' : 'disabled'}",
      onclick: card.legal && "submitGame(#{card.slug})"
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
    # [
    #   ['Trischaken', :trischaken],
    #   ['Sechserdreier', :sechserdreier],
    #   ['Call a king', :call_king]
    # ]
    {
      trischaken: 'Trischaken',
      sechserdreier: 'Sechserdreier',
      call_king: 'Call a king'
    }
  end

  private

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
