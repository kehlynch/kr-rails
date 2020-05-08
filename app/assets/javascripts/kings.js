function updateKings(oldData, newData) {
  console.log("update kings");
  const updaters = {
    'visible': (visible) => { toggle(sections.KINGS, visible) },
    'instruction': setKingsInstruction,
    'kings': updateKingCards,
  }

  Object.entries(newData).forEach ( ( [ name, newValue] ) => {
    const oldValue = oldData[name];
    if ( JSON.stringify(oldValue) != JSON.stringify(newValue)) {
      updaters[name](newValue, oldValue);
    }
  })
}


function updateKingCards(newData, oldData) {
  console.log("updateKingCards", newData);
  newData.forEach ( ( cardData, i ) => {
    const oldCardData = oldData[i];
    if ( JSON.stringify(oldCardData) != JSON.stringify(cardData)) {
      updateKingCard(cardData);
    }
  })
}

function updateKingCard(data) {
  console.log("updateKingCard", data);
  const cardSelector = `#js-king-card-${data.slug}`;
  const classes = `kr-card ${data.own_king && 'own_king'} ${data.pickable && 'pickable'} ${data.picked && 'selected'}`
  $(cardSelector).attr('class', classes)
}

function setKingsInstruction(message) {
  clear(sections.KINGS_INSTRUCTION);
  addTo(sections.KINGS_INSTRUCTION, message);
}

