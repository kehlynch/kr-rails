function updateBids(newData, oldData) {
  const updaters = {
    'instruction': setInstruction,
    'bid_picker': setBidPicker,
    'hand': updateHand
  }

  const updatersNeedingStage = {
    'players': setPlayerBids,
    'finished_message': setFinishedMessage,
    'finished': toggleBidsFinishedMessage,
  }

  const stage = newData.stage;

  Object.entries(newData).forEach ( ( [ name, newValue] ) => {
    const oldValue = oldData[name];
    if ( JSON.stringify(oldValue) != JSON.stringify(newValue)) {
      if (updaters[name]) {
        updaters[name](newValue, oldValue);
      } else if (updatersNeedingStage[name]) {
        updatersNeedingStage[name](stage, newValue, oldValue);
      }
    }
  })
}

function setPlayerBids(type, players, oldPlayers) {
  players.forEach((player, i) => {
    if ( JSON.stringify(player) != JSON.stringify(oldPlayers[i])) {
      const sectionSelector = `#js-player-${player.id}-${type}`
      const bidIndicators = player.bids.map((bid) => (playerBidIndicator(bid)));
      $(sectionSelector).empty().append(bidIndicators);
    }
  })
}

function playerBidIndicator(bid) {
	return `<div class="player-bid-made">${bid}</div>`
}

function toggleBidsFinishedMessage(type, visible) {
  $(finishedMessageSelector(type)).toggleClass('d-none', !visible);
}

function setFinishedMessage(type, message) {
  $(finishedMessageSelector(type)).empty().append(`<i class="fa fa-gavel"></i>${message}`);
}

function finishedMessageSelector(type) {
  return `#js-${type}-finished-message`;
}

function setBidPicker({ visible, type, valid_bids }) {
  const selector = `#js-${type}-picker`;
  const html = valid_bids.map(({slug, name}) => {
    return bidButtonHtml(slug, name, type);
  })
  $(selector).empty().append(html);
  $(selector).toggleClass('d-none', !visible);
}

function bidButtonHtml(slug, name, type) {
  const input = `<input hidden="true" id="valid-${type}-${slug}" name="game[${type}]" type="checkbox" value="${slug}">`;
  const button = `<button name="button" type="button" alt="${name}" class="btn btn-outline-dark" onclick="submitBid('${slug}', '${type}')">${name}</button>`;
  return input + button;
}

function submitBid(bidSlug, bidOrAnnouncement) {
  submitGame($(`#valid-${bidOrAnnouncement}-${bidSlug}`));
}
