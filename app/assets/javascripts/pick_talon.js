function updatePickTalon(newData, oldData) {
  const updaters = {
    'instruction': setInstruction,
    'hand': updateHand,
    'halves': updateTalonHalves,
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

function updateTalonHalves(halves) {
  halves.forEach(({ disabled, classes, index } ) => {
    const selector = `#js-talon-half-${index}`
    $(selector).attr('class', `talon-half-container ${classes}`);
    $(selector).prop('disabled', disabled);
  })
}
