function updateBids(oldData, newData) {
  const updaters = {
    'visible': (visible) => { toggle(sections.BIDS, visible) },
    'bid_picker_visible': toggleBidPicker,
    'finished': toggleBidsFinishedMessage,
    'finished_message': setFinishedMessage,
    'instruction': setBidInstruction,
    'valid_bids': setValidBids
  }

  Object.entries(newData).forEach ( ( [ name, newValue] ) => {
    const oldValue = oldData[name];
    if ( JSON.stringify(oldValue) != JSON.stringify(newValue)) {
      updaters[name](newValue);
    }
  })
}

function toggleBidPicker(visible) {
  toggle(sections.BID_PICKER, visible);
}

function toggleBidsFinishedMessage(visible) {
  toggle(sections.BIDS_FINISHED_MESSAGE, visible);
}

function setFinishedMessage(message) {
  clear(sections.BIDS_FINISHED_MESSAGE);
  addTo(sections.BIDS_FINISHED_MESSAGE, `<i class="fa fa-gavel"></i>${message}`)
}

function setBidInstruction(message) {
  console.log("setInstruction", message);
  clear(sections.BID_INSTRUCTION);
  addTo(sections.BID_INSTRUCTION, message);
}

function setValidBids(validBidsData) {
  clear(sections.BID_PICKER)
  const html = validBidsData.map((bid) => {
    return bidButtonHtml(bid.slug, bid.name);
  })
  addTo(sections.BID_PICKER, html);
}

function bidButtonHtml(slug, name) {
  const input = `<input hidden="true" id="valid-bid-${slug}" name="game[make_bid]" type="checkbox" value="${slug}">`;
  const button = `<button name="button" type="button" alt="${name}" class="btn btn-outline-dark" onclick="submitBid('${slug}', 'bid')">${name}</button>`;
  return input + button;
}

function submitBid(bidSlug, bidOrAnnouncement) {
  submitGame($(`#valid-${bidOrAnnouncement}-${bidSlug}`));
}
