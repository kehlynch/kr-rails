function updateHand(cards) {
  if ( $('#js-hand').find('img').length != cards.length ) {
    $("#js-hand").empty()
  }
  cards.forEach((c) => {
    updateCard(c.slug, c.legal);
  })
}

function updateCard(slug, legal) {
  // TODO toggling talon putdowns
  const inputId = `hand_${slug}`
  const talonStage = ['resolve_talon', 'resolve_whole_talon'].includes(stage());
  const action = talonStage ? 'toggleCard' : 'playCard';
  const pickableClass = meToPlayHandCard() ? 'pickable' : '';
  const legalClass = legal ? '' : 'illegal';
  const classes = `kr-card ${pickableClass} ${legalClass}`
  const onclick = legal ? `${action}(${inputId})` : '';

  const inputName = `game[${stage()}][]`
  addOrUpdateCard(slug, classes, onclick, inputId, inputName);

  if (talonStage && myMove()) {
    revealResolveTalonButton();
  }
}

function addOrUpdateCard(slug, classes, onclick, inputId, inputName) {
  if ($(`#${inputId}`).length) {
    $(`#${inputId}`).attr('name', inputName);
    $(`#${inputId}`).next().attr('class', classes);
    $(`#${inputId}`).next().attr('onclick', onclick);
  } else {
    addCard(slug, classes, onclick, inputId, inputName);
  }
}

function addCard(slug, classes, onclick, inputId, inputName) {
  const input = (`<input hidden=true id="${inputId}" name="game[${stage()}][]" type="checkbox" value="${slug}" />`);

  const image = `<img alt="${slug}" class="${classes}" onclick="${onclick}" src="/assets/${slug}.jpg">`
  $("#js-hand").append(`<div class="card-container hand">${input}${image}</div>`)
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
