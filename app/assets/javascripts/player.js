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

  if (oldData.announcements !== newData.announcements) {
    $(`#js-player-${newData.id}-announcements-indicators`).empty().append(newData.announcements);
  }
}

function updateRoleIndicators(newData, oldData) {
  ['forehand', 'declarer', 'partner'].forEach((type) => {
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
  $(spinnerSelector).toggleClass('spinner-invisible', !visible);
}

