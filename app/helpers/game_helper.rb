module GameHelper
  def winner_icon(player)
    return "" unless player.winner?

    return "⭐️"
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

  def card_tag(card_slug, classes: '', onclick: nil, landscape: false, id: nil, disabled: false)
    filename = landscape ? "landscape_#{card_slug}.jpg" : "#{card_slug}.jpg"
    image_tag(
      filename,
      alt: card_slug,
      class: "kr-card #{classes}",
      onclick: onclick,
      id: id,
      disabled: disabled
    )
  end
end
