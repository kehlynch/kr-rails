//= require jquery3

const BID_NAMES = {
  'pass': 'Pass',
  'rufer': 'Rufer',
  'solo': 'Solo',
  'piccolo': 'Piccolo',
  'besser_rufer': 'Besser Rufer',
  'dreier': 'Dreier',
  'solo_dreier': 'Solo Dreier',
  'bettel': 'Bettel',
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
  const input = `
    <input 
      hidden=true
      id="valid-bid-${slug}"
      name="game[make_bid]"
      type="checkbox"
      value="${slug}"
    />
  `
  const button = `
    <button
      name="button"
      type="button"
      alt="${slug}"
      class="btn btn-outline-dark"
      onclick="submitBid('${slug}', 'bid')"
    >
      ${name}
    </button>
  `
  $(`#js-valid-bids`).append(input)
  $(`#js-valid-bids`).append(button)
}

function addValidBids(slugs) {
  console.log("addValidBids", slugs);
  $(`#js-valid-bids`).empty();
  slugs.forEach(addValidBid)
  $('#js-valid-bids').removeClass("d-none");
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
  $(`#js-player-${declarerPosition}-declarer-indicator`).removeClass('d-none');
  $("#js-valid-bids").empty();
  setState('won-bid', slug);
  // TODO I think this breaks in multiplayer - we'll need to start identifying players by ID?
  setState('is-declarer', declarerPosition == 0);
}

function submitBid(bidSlug, bidOrAnnouncement) {
  submitGame($(`#valid-${bidOrAnnouncement}-${bidSlug}`));
  $(`#js-valid-${bidOrAnnouncement}`).empty();
}
