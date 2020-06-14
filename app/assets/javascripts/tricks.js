function updateTricks(newData, oldData) {
  newData.tricks.forEach ( ( newTrickData, index ) => {
    const oldTrickData = oldData.tricks[index];
    if ( JSON.stringify(newTrickData) != JSON.stringify(oldTrickData)) {
      updateTrick(newTrickData, oldTrickData);
    }
  })
}

function updateTrick(newData, oldData) {
  const updaters = {
    'instruction': setInstruction,
    'hand': updateHand,
		'cards': updateTrickCards,
  }

  Object.entries(newData).forEach ( ( [ name, newValue ] ) => {
    const oldValue = oldData && oldData[name];
    if ( !oldValue || (JSON.stringify(newValue) != JSON.stringify(oldValue))) {
      const updater = updaters[name]
      if (updater) {
        updaters[name](newValue, oldValue);
      }
    }
  })

  const visible = newData.index == getState(state.VISIBLE_TRICK_INDEX)

  $(trickSelector(newData.index)).toggleClass('d-none', !visible);
}

function updateTrickCards(cardsData) {
  cardsData.forEach((cardData, i) => {
    updateTrickCard(cardData);
  })
}

function updateTrickCard(cardData) {
  const { slug, won, input_id } = cardData;
  const selector = `#${input_id}`
  if ($(selector).length) {
    $(selector).toggleClass('won', won);
  } else {
    addTrickCard(cardData);
  }
}

function addTrickCard(cardData) {
  const { input_id, slug, landscape, trick_index, compass } = cardData;
  const card = cardHtml(slug, 'trickcard', null, input_id, landscape);
  const html = `<div class="card-container trick-card-container ${compass}">${card}</div>`
  $(trickSelector(trick_index)).find('.trick-container').append(html);
  updateTrickCard(cardData);
}

function trickSelector(trickIndex) {
  return `#js-trick-${trickIndex}`
}

function revealTrickAndHideOthers(trickIndexToReveal) {
  [...Array(12).keys()].forEach((trickIndex) => {
    $(trickSelector(trickIndex)).toggleClass('d-none', trickIndex != trickIndexToReveal);
  })
}
