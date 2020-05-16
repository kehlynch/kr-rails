function updateHand(newData, oldData) {
  console.log('updateHand', newData);
  const { id, hand } = newData;
  const handSlugs = hand.map((c) => c.slug);
  const oldHandSlugs = oldData.hand.map((c) => c.slug);

  if (JSON.stringify(handSlugs) != JSON.stringify(oldHandSlugs)) {
    resetHand(newData);
  } else { 
    hand.forEach((card, i) => {
      const oldCard = oldData.hand[i];
      if ((JSON.stringify(card) != JSON.stringify(oldCard))) {
        updateHandCard(card)
      }
    })
  }
}

function updateHandCard({input_id, pickable, illegal, onclick}) {
  const image = $(`#${input_id}`).next();
  $(image).toggleClass('pickable', pickable);
  $(image).toggleClass('illegal', illegal);
  $(image).attr('onclick', onclick);
}

function resetHand({ id, hand }) {
  const cards = hand.map((c) => handCard(c)).join(" ")

  $(`#${id}`).empty().append(cards);
}

function handCard({ input_id, stage, slug, onclick, pickable, illegal }) {
  const input = (`<input hidden=true id="${input_id}" name="game[${stage}][]" type="checkbox" value="${slug}" />`);

  const classes = `kr-card ${pickable && 'pickable'} ${illegal && 'illegal'}`

  const image = `<img alt="${slug}" onclick="${onclick}" class="${classes}" src="/assets/${slug}.jpg">`

  return `<div class="card-container hand">${input}${image}</div>`
}
