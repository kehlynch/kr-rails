function updateHand(cards) {
  $("#js-hand").empty()
  cards.forEach((c) => {
    addCard(c.slug, c.legal);
  })
}

function addCard(slug, legal) {
  const id = `${stage()}_${slug}`
  // TODO toggling talon putdowns
  const talonStage = ['resolve_talon', 'resolve_whole_talon'].includes(stage());
  const action = talonStage ? 'toggleCard' : 'playCard';
  const pickableClass = meToPlayHandCard() ? 'pickable' : '';
  const legalClass = legal ? '' : 'illegal';
  const onclick = legal ? `${action}(${id})` : '';
  const input = (`<input hidden=true id="${id}" name="game[${stage()}][]" type="checkbox" value="${slug}" />`);

  const image = `<img alt="${slug}" class="kr-card ${pickableClass} ${legalClass}" onclick="${onclick}" src="/assets/${slug}.jpg">`
  $("#js-hand").append(`<div class="card-container hand">${input}${image}</div>`)

  if (talonStage && myMove()) {
    revealResolveTalonButton();
  }
}

function cardAction(slug, legal) {
  const action = talonStage ? 'toggleCard' : 'playCard';
}

function updateHandPickable() {
  if (meToPlayHandCard()) {
    makeHandPickable();
  } else {
    makeHandUnpickable();
  }
}

function makeHandUnpickable() {
  $("#js-hand").find("img").removeClass("pickable")
}

function makeHandPickable() {
  $("#js-hand").find("img").addClass("pickable")
}
