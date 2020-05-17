function updateHTML(stateName, oldValue, newValue) {
  const updaters = {
    [state.PLAYERS]: updatePlayers,
    [state.CONTRACT]: updateContract,
    [stages.BID]: updateBids,
    [stages.KING]: updateKings,
    [stages.PICK_TALON]: updatePickTalon,
    [stages.RESOLVE_TALON]: updateResolveTalon,
    [stages.ANNOUNCEMENT]: updateBids,
    [stages.TRICK]: updateTricks,
    [stages.FINISHED]: updateFinished
  }

  const updater = updaters[stateName];
  
  if (updater) {
    updater(newValue, oldValue)
  }
}

function applyChange(data) {
  Object.entries(data).forEach ( ( [ name, newState ] ) => {
    const oldState = getState(name);
    if (JSON.stringify(oldState) != JSON.stringify(newState)) {
      updateHTML(name, oldState, newState);
      if (![state.VISIBLE_STAGE, state.VISIBLE_TRICK_INDEX].includes(name)) {
        setState(name, newState);
      }
    }
  })

  setInProgress(false);
}
