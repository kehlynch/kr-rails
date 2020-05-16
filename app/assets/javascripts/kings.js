function updateKings(newData, oldData) {
  console.log("update kings");
  const updaters = {
    'instruction': setInstruction,
    'kings': updateKingCards,
    'hand': updateHand
  }

  Object.entries(newData).forEach ( ( [ name, newValue] ) => {
    const oldValue = oldData[name];
    if ( JSON.stringify(oldValue) != JSON.stringify(newValue)) {
      const updater = updaters[name]
      if (updater) {
        updaters[name](newValue, oldValue);
      }
    }
  })
}


function updateKingCards(newData, oldData) {
  newData.forEach ( ( cardData, i ) => {
    const oldCardData = oldData[i];
    if ( JSON.stringify(oldCardData) != JSON.stringify(cardData)) {
      updateKingCard(cardData);
    }
  })
}

function updateKingCard({ input_id, classes }) {
  $(`#${input_id}`).next().attr('class', `kr-card ${classes}`)
}

