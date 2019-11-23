function stage() { return state().stage; }

function wonBid() { return state().wonBid; }

function isDeclarer() { return state().isDeclarer == 'true'; }

function myMove() { return state().myMove == 'true'; }

function playerId() { return state().playerId; }

function matchId() { return state().matchId; }

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

function gameId() {
  const element = document.getElementById('js-state-game-id');
  return element ? element.dataset.gameId : null;
}

function setState(key, value) {
  $('#js-state').attr(`data-${key}`, value);
}

function updateSubscriptionsOnGameChange() {
  $('#js-state-game-id').on('change', () => {
    createSubscriptions();
  });
}

$(document).ready(function() {
  updateSubscriptionsOnGameChange();
})
