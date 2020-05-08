STATE_SELECTOR = '#js-state';

const state = {
  PATHS: 'paths',
  CHANNEL: 'channel',
  PLAYERS: 'players',
  BIDS: 'bids',
  KINGS: 'kings',
  ANNOUNCEMENTS: 'announcements',
  INSTRUCTION: 'instruction',
  ACTION: 'action',
  PLAYABLE_TRICK_INDEX: 'playable_trick_index',
  VISIBLE_TRICK_INDEX: 'visible_trick_index',
  DECLARER_NAME: 'declarer_name',
  IS_DECLARER: 'is_declarer',
  KING_NEEDED: 'king_needed',
  PICKED_KING_SLUG: 'picked_king_slug',
  PLAYER_POSITION: 'player_position',
  MY_MOVE: 'my_move',
  TALON_PICKED: 'talon_picked',
  TALON_CARDS_TO_PICK: 'talon_cards_to_pick',
  VISIBLE_STAGE: 'visible_stage',
  WON_BID: 'won_bid',
  IN_PROGRESS: 'in_progress' // only set from JS
}

function getState(state) {
  if ( !$(STATE_SELECTOR).length ) { return }
  
  const jsonValue = $(STATE_SELECTOR).attr(state);
  if (jsonValue) {
    return JSON.parse(jsonValue);
  }
}

function advanceAvailable() {
  return getState(state.BIDS).finished
}

function setState(key, value) {
  $(STATE_SELECTOR).attr(key, JSON.stringify(value));
}

function currentTrickIndex() { return getState(state.PLAYABLE_TRICK_INDEX) }

function visibleTrickIndex() { return getState(state.VISIBLE_TRICK_INDEX) }

function declarerName() { return getState(state.DECLARER_NAME) }

function isDeclarer() { return getState(state.IS_DECLARER) }

function kingNeeded() { return getState(state.KING_NEEDED) }

function pickedKingSlug() { return getState(state.PICKED_KING_SLUG) }

function myMove() { return getState(state.MY_MOVE) }

function playerPosition() { return getState(state.PLAYER_POSITION); }

function talonPicked() { return getState(state.TALON_PICKED); }

function talonCardsToPick() { return getState(state.TALON_CARDS_TO_PICK); }

function visibleStage() { return getState(state.VISIBLE_STAGE) }

function wonBid() { return getState(state.WON_BID) }

function inProgress() { return getState(state.IN_PROGRESS) }

function meToPlayHandCard() {
  if (!myMove()) { return false; }
  if (stage() == 'play_card') { return (currentTrickIndex() == visibleTrickIndex()); }
  if (['resolve_talon', 'resolve_whole_talon'].includes(stage())) { return true; };
  return false;
}

function setInProgress(value=true) {
  setState(state.IN_PROGRESS, value);
  value ? makeHandUnpickable() : makeHandPickable;
  toggle(sections.PROGRESS_SPINNER, value);
}

function setContinueAvailable(value=true) {
  setState(state.CONTINUE_AVAILABLE, value);
}
