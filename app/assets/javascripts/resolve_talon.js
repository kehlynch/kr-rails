function updateResolveTalon(newData, oldData) {
  const updaters = {
    'instruction': setInstruction,
    'hand': updateHand,
		'resolvable': updateResolvable
  }

  Object.entries(newData).forEach ( ( [ name, newValue] ) => {
    const oldValue = oldData[name];
    if ( JSON.stringify(oldValue) != JSON.stringify(newValue)) {
      const updater = updaters[name]
      if (updater) {
        updaters[name](newValue, oldValue);
      }
    }
  })
}

function updateResolvable(resolvable) {
  $('#js-resolve-talon-button').toggleClass('d-none', !resolvable);
}
