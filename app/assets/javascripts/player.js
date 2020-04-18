function addPlayerInfo(data) {
  const lookup = {
    'instruction': setInstruction,
    'valid_bids': addValidBids,
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

function setInstruction(inst) {
  $('#instruction').empty();
  $('#instruction').append(inst);
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

function setKingsPickable(pickable) {
  if (pickable) {
    $("#js-kings").find("img").addClass("pickable");
  } else {
    $("#js-kings").find("img").removeClass("pickable");
  }
}

