# frozen_string_literal: true

module GameHelper
  def card_button(card)
    image_tag(
      "#{card.slug}.jpg",
      alt: card.slug,
      class: "card js-submit-card #{card.legal ? '' : 'disabled'}",
      onclick: card.legal && "submitCard(#{card.slug})"
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

  private

  def find_player_card(cards, position)
    cards.find { |c| c.player == position }
  end

  def player_info(position, runner)
    # player = players.find { |p| p.position == position }
    trick_count = runner.tricks.select(&:finished).select do |t|
      t.winning_player == position
    end.length
    {
      trick_count: trick_count,
      lead: runner.lead_player_position == position,
      points: runner.players[position].points
    }
  end
end
