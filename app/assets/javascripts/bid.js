//= require jquery3

const BID_NAMES = {
  'pass': 'Pass',
  'rufer': 'Rufer',
  'solo': 'Solo',
  'besser_rufer': 'Besser Rufer',
  'dreier': 'Dreier',
  'solo_dreier': 'Solo Dreier',
  'call_king': 'Call a king',
  'trischaken': 'Trischaken',
  'sechserdreier': 'Sechserdreier'
}

function addBid(slug, player) {
  const name = BID_NAMES[slug]
  $(`#js-player-${player}-bids`).append(`<h6 class="card-subtitle mb-2 text-muted">${name}</h6>`)
}

function addValidBid(slug) {
  const name = BID_NAMES[slug];
  const input = `<input hidden=true id="${slug}" name="game[make_bid]" type="checkbox" value="${slug}" />`
  const button = `<button name="button" type="button" alt="${slug}" class="btn btn-outline-dark" onclick="submitBid(${slug})">${name}</button>`
  $(`#js-valid-bids`).append(input)
  $(`#js-valid-bids`).append(button)
}

function setWonBid(slug, declarerPosition) {
  [0, 1, 2, 3].forEach((player) => {
    $(`#js-player-${player}-bids`).empty();
  })
  $("#js-message-header").empty();
  $("#js-message-header").append(slug == 'call_king' ? 'Rufer' : BID_NAMES[slug]);
  // delete made bids
  $(`#player-${declarerPosition}-bids`).empty();
  // add declarer indicator
  $(`#player-${declarerPosition}-top-info`).append(`<h6 class="card-subtitle mb-2 text-muted">Declarer</h6>`);
  $("#js-valid-bids").empty();
  setState('won-bid', slug);
}

function submitBid(bidSlug) {
  console.log("submitBid", bidSlug);
  submitGame(bidSlug);
  $("#js-valid-bids").empty();
}
