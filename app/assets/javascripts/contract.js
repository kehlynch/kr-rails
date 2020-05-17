function updateContract(newData, oldData) {
  console.log('updateContract', newData);
  const updaters = {
    'won_bid': setWonBid,
    'calledKing': setCalledKing
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

function setWonBid(newBidName) {
  $('#js-won-bid').empty().append(newBidName);
}

function setCalledKing(newKingSlug) {
  $('#js-contract-king').empty().append(`<img alt="${spade_8}" class="kr-card" src="${cardImagePath(slug)}">`);
}
