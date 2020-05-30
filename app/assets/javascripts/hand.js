function updateHand(newData, oldData) {
  const { id, hand } = newData;
  const handSlugs = hand.map((c) => c.slug);
  const oldHandSlugs = oldData.hand.map((c) => c.slug);

  if (JSON.stringify(handSlugs) != JSON.stringify(oldHandSlugs)) {
    newCards = handSlugs.filter(s => !oldHandSlugs.includes(s));
    if (newCards.length > 0) {
      // re-render so we put them in sorted order, for when talon is picked
      $(`#${id}`).empty();
      hand.forEach((cardData) => {
        const card = handCard(cardData);
        $(`#${id}`).append(card);
      })
    } else {
      syncHandCards(newData, oldData);
    }
  }

  hand.forEach((card, i) => {
    const oldCard = oldData.hand[i];
    if ((JSON.stringify(card) != JSON.stringify(oldCard))) {
      updateHandCard(card)
    }
  })
}

function updateHandCard({input_id, pickable, illegal, onclick, disabled}) {
  const image = $(`#${input_id}`).next();
  $(image).toggleClass('pickable', pickable);
  $(image).toggleClass('illegal', illegal);
  $(image).attr('onclick', onclick);
  $(image).attr('disabled', disabled);
}

function syncHandCards(newData, oldData) {
  addNewCards(newData, oldData);
  removeOldCards(newData, oldData);
}

function addNewCards({ id, hand }, oldData) {
  const oldHand = oldData.hand;
  hand.forEach((cardData) => {
    const inOldHand = oldHand.find((c) => c.slug == cardData.slug);
    if (!inOldHand) {
      const card = handCard(cardData);
      // not a great solution cos they end up out of order
      $(`#${id}`).append(card);
    }
  })
}

function removeOldCards({ id, hand }, oldData) {
  const oldHand = oldData.hand;
  oldHand.forEach((cardData) => {
    const inNewHand = hand.find((c) => c.slug == cardData.slug);
    if (!inNewHand) {
      const card = handCard(cardData);
      $(`#${id}`).find(`[value="${cardData.slug}"]`).parent().remove()
    }
  })
}

function handCard({ input_id, stage, slug, onclick, pickable, illegal }) {
  const input = (`<input hidden=true id="${input_id}" name="game[${stage}][]" type="checkbox" value="${slug}" />`);

  const classes = `kr-card ${pickable && 'pickable'} ${illegal && 'illegal'}`

  const image = `<img alt="${slug}" onclick="${onclick}" class="${classes}" src="/assets/${slug}.jpg">`

  return `<div class="card-container hand">${input}${image}</div>`
}
