function updateResolveTalon(newData, oldData) {
  const updaters = {
    'instruction': setInstruction,
    'hand': updateHand,
		'resolvable': (resolvable) => { toggle(sections.TALON_SUBMIT, resolvable) }
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
