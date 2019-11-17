function stage() { return state().stage; }

function wonBid() { return state().wonBid; }

function isDeclarer() { return state().isDeclarer == 'true'; }

function myMove() { return state().myMove == 'true'; }

function gameId() { return state().gameId; }

function playerId() { return state().playerId; }

function playerPosition() { return state().playerPosition; }

function currentTrickIndex() { return state().currentTrick; }

function visibleTrickIndex() { return state().visibleTrick; }

function meToPlayCard() {
  return myMove() && (currentTrickIndex() == visibleTrickIndex());
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
