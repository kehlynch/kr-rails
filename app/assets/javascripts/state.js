function stage() {
  return state().stage;
}

function wonBid() {
  return state().wonBid;
}

function myMove() {
  return state().myMove == 'true';
}

function playerId() {
  return state().playerId;
}

function gameId() {
  return state().gameId;
}

function state() {
  const element = document.getElementById('js-state');
  const state = element ? element.dataset : {};
  return state;
}

function setNextPlayer(nextPlayerId) {
  setState('my-move', playerId() == nextPlayerId)
}

function setState(key, value) {
  console.log("setState", key, value);
  $('#js-state').attr(`data-${key}`, value);
}
