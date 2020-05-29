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
  // really ugly way to get image path from the exisitng html cos Heroku adds strings to them
  const imageSrc = $(`img[alt=${newKingSlug}]`).attr('src');
  $('#js-contract-king').empty().append(`<img alt="${newKingSlug}" class="kr-card" src="${imageSrc}">`);
}
