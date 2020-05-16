function updatePlayers(newData, oldData) {
  oldData.forEach((oldPlayerData, i) => {
    updatePlayer(newData[i], oldPlayerData);
  })
}

function updatePlayer(newData, oldData) {
  if (JSON.stringify(oldData) == JSON.stringify(newData)) { return }

  if (oldData.next_to_play != newData.next_to_play) { 
    toggleSpinnerFor(newData.id, newData.next_to_play);
  }

  updateRoleIndicators(newData, oldData);
  if (oldData.message != newData.message) {
    updateMessage(newData.id, newData.message);
  }
}

function updateRoleIndicators(newData, oldData) {
  ['forehand', 'declarer', 'known_partner'].forEach((type) => {
    if (oldData[type] !== newData[type]) {
      updateRoleIndicator(type, newData.id, newData[type])
    }
  })
}

function updateRoleIndicator(type, playerId, visible) {
  const indicatorSelector = `#js-player-${playerId}-${type}-indicator`;
  $(indicatorSelector).toggleClass('d-none', !visible);
}

function toggleSpinnerFor(playerId, visible) {
  const spinnerSelector = `#js-spinner-player-${playerId}`
  $(spinnerSelector).toggleClass('d-none', !visible);
}

function addPlayerInfo(data) {
  const lookup = {
    // 'valid_bids': addValidBids,
    'valid_announcements': setValidAnnouncements,
    'partner': setPartner,
    'my_move': setMyMove,
    'hand': updateHand,
    'pick_king': setKingsPickable,
    'pick_talon': setTalonPickable,
    'resolve_talon': setTalonResolvable,
    'scores': addScores,
    'game_summaries': addGameSummaries
  }
  Object.entries(lookup).forEach(([k, f]) => {
    if (data.hasOwnProperty(k)) { f(data[k]) };
  })
}

function setMyMove(myMove) {
  setState('my-move', myMove);
}

function setPartner(partner) {
  if (partner == 'talon') {
    $(`#js-king`).addClass('in-talon')
  } else {
    $(`#js-player-${partner}-partner-indicator`).removeClass('d-none');
  }
}

function setNextPlayer(playerPosition) {
  [0, 1, 2, 3].forEach((p) => {
    $(`#js-player-${p}-waiting`).addClass('d-none');
  })

  $(`#js-player-${playerPosition}-waiting`).removeClass('d-none');
}

function addDeclarerIndicator(playerPosition) {
  $(`#js-player-${playerPosition}-declarer-indicator`).removeClass('d-none');
}
