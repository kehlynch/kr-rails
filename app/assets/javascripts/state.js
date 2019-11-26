function stage() { return state().stage; }

function wonBid() { return state().wonBid; }

function isDeclarer() { return state().isDeclarer == 'true'; }

function myMove() { return state().myMove == 'true'; }

function inProgress() { return state().inProgress == 'true'; }

function playerId() { return state().playerId; }

function matchId() { return state().matchId; }

function playerPosition() { return state().playerPosition; }

function currentTrickIndex() { return state().currentTrick; }

function visibleTrickIndex() { return state().visibleTrick; }

function meToPlayHandCard() {
  if (!myMove()) { return false; }
  if (stage() == 'play_card') { return (currentTrickIndex() == visibleTrickIndex()); }
  if (['resolve_talon', 'resolve_whole_talon'].includes(stage())) { return true; };
  return false;
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

function setInProgress(value) {
  $('#js-state').attr(`data-in-progress`, value);
}

function updateSubscriptionsOnGameChange() {
  $('#js-state-game-id').on('change', () => {
    createSubscriptions();
  });
}

$(document).ready(function() {
  updateSubscriptionsOnGameChange();
})
