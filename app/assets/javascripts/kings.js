function updateKings(oldData, newData) {
  console.log("update bids");
  const updaters = {
    'visible': (visible) => { toggle(sections.BIDS, visible) },
    'bid_picker_visible': toggleBidPicker,
    'finished': (finished) => { toggle(sections.BIDS_FINISHED_MESSAGE, finished) },
    'finished_message': setFinishedMessage,
    'instruction': setInstruction,
    'valid_bids': setValidBids
  }

  Object.entries(newData).forEach ( ( [ name, newValue] ) => {
    const oldValue = oldData[name];
    if ( JSON.stringify(oldValue) != JSON.stringify(newValue)) {
      updaters[name](newValue);
    }
  })
}

