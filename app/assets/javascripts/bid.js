//= require jquery3

const bids = {
  PASS: 'pass',
  RUFER: 'rufer',
  SOLO: 'solo',
  PICCOLO: 'piccolo',
  BESSER_RUFER: 'besser_rufer',
  DREIER: 'dreier',
  SOLO_DREIER: 'solo_dreier',
  BETTEL: 'bettel',
  CALL_KING: 'call_king',
  TRISCHAKEN: 'trischaken',
  SECHSERDREIER: 'sechserdreier'
}

const bidNames = {
  [bids.PASS]: 'Pass',
  [bids.RUFER]: 'Rufer',
  [bids.SOLO]: 'Solo',
  [bids.PICCOLO]: 'Piccolo',
  [bids.BESSER_RUFER]: 'Besser Rufer',
  [bids.DREIER]: 'Dreier',
  [bids.SOLO_DREIER]: 'Solo Dreier',
  [bids.BETTEL]: 'Bettel',
  [bids.CALL_KING]: 'Call a king',
  [bids.TRISCHAKEN]: 'Trischaken',
  [bids.SECHSERDREIER]: 'Sechserdreier'
}

function addBid(bid) {
  if (!bid) { return };
  const name = bidNames[bid.slug]
  console.log("addBid", name, bid.slug, bidNames);
  addSpeech(bid.player.position, name);

  message = bidMsg(bid)
  addMessage([message])
  if (bid.finished) {
    setWonBid(bid.slug, bid.player.position);
    setContinueInstruction();
    setContinueAvailable();
  }
  // $(`#js-player-${bid.player}-bids`).append(`<h6 class="card-subtitle mb-2 text-muted">${name}</h6>`)
}

function bidMsg(bid) {
  const name = bidNames[bid.slug]
  if (bid.finished) {
    return bidFinishedMsg(bid);
  } else if (bid.slug == bids.PASS) {
    return `${bid.player.name} passes`;
  } else {
    return `${bid.player.name} bids ${name}`;
  }
}

function bidFinishedMsg(bid) {
  const name = bidNames[bid.slug];
  if (bid.slug == bids.CALL_KING) {
    return `${bid.player.name} wins bidding with Rufer and calls a King` 
  } else {
    return `${bid.player.name} wins bidding with ${name}`
  }
}

function addValidBid(slug) {
  const name = bidNames[slug];
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
  $(`#js-valid-bids`).empty();
  slugs.forEach(addValidBid)
  showBidPicker();
}

function setWonBid(slug, declarerPosition) {
  clearAllSpeech();
  $("#js-message-header").empty();
  $("#js-message-header").append(slug == 'call_king' ? 'Rufer' : bidNames[slug]);
  addDeclarerIndicator(declarerPosition);
  emptyBidPicker();
  setState('won-bid', slug);
  setState('is-declarer', declarerPosition == playerPosition());
}

function submitBid(bidSlug, bidOrAnnouncement) {
  submitGame($(`#valid-${bidOrAnnouncement}-${bidSlug}`));
  $(`#js-valid-${bidOrAnnouncement}`).empty();
}

function showBidPicker() {
  reveal(sections.BID_PICKER);
}

function hideBidPicker() {
  hide(sections.BID_PICKER);
}

function emptyBidPicker() {
  clear(sections.BID_PICKER);
}
