function updateHand(cards) {
  $("#js-hand").empty()
  cards.forEach((c) => {
    const slug = c.slug;
    const id = `${stage()}_${c.slug}`
    if (c.legal) {
      $("#js-hand").append(`<input hidden=true id="${id}" name="game[${stage()}][]" type="checkbox" value="${stage()}" />`)
    }
    // TODO toggling talon putdowns
    const action = 'submitGame';
    const onclick = c.legal ? `${action}(${id})` : ''
    const pickableClass = c.legal ? 'pickable' : 'illegal'

    const image = `<img alt="${slug}" class="kr-card ${pickableClass}" onclick="${onclick}" src="/assets/${slug}.jpg">`
    $("#js-hand").append(`<div class="card-container hand">${image}</div>`)
  })
}
