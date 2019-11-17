function updateHand(cards) {
  console.log("updateHand");
  $("#js-hand").empty()
  cards.forEach((c) => {
    addCard(c.slug, c.legal);
  })
}

function addCard(slug, legal, active) {
  const id = `${stage()}_${slug}`
  // TODO toggling talon putdowns
  const action = stage() == 'resolve_talon' ? 'toggleCard' : 'submitGame'
  const pickableClass = meToPlayCard() ? 'pickable' : ''
  const legalClass = legal ? '' : 'illegal'
  const onclick = legal ? `${action}(${id})` : ''
  const input = (`<input hidden=true id="${id}" name="game[${stage()}][]" type="checkbox" value="${slug}" />`)

  const image = `<img alt="${slug}" class="kr-card ${pickableClass} ${legalClass}" onclick="${onclick}" src="/assets/${slug}.jpg">`
  $("#js-hand").append(`<div class="card-container hand">${input}${image}</div>`)

  if (stage() == 'resolve_talon' && myMove()) {
    revealResolveTalonButton();
  }
}

function updateHandPickable() {
  if (meToPlayCard()) {
    $("#js-hand").find("img").addClass("pickable")
  } else {
    $("#js-hand").find("img").removeClass("pickable")
  }
}
