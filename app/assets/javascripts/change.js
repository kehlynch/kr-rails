function updateHTML(stateName, oldValue, newValue) {
  const updaters = {
    [state.PLAYERS]: updatePlayers,
    [state.BIDS]: updateBids,
    [state.KINGS]: updateKings,
  }

  const updater = updaters[stateName];
  
  if (updater) {
    updater(oldValue, newValue)
  }
}

function applyChange(data) {
  Object.entries(data).forEach ( ( [ name, newState ] ) => {
    const oldState = getState(name);
    if (JSON.stringify(oldState) != JSON.stringify(newState)) {
      updateHTML(name, oldState, newState);
      if (name != state.VISIBLE_STAGE) {
        setState(name, newState);
      }
    }
  })
}
