function updateContract(newData, oldData) {
  const updaters = {
    'won_bid': setWonBid,
    'called_king': setCalledKing
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
  const html = cardHtml(newKingSlug);
  $('#js-contract-king').empty().append(html);
}
