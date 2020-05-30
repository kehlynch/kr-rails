const stages = {
  BID: 'bids',
  KING: 'kings',
  PICK_TALON: 'pick_talon',
  RESOLVE_TALON: 'resolve_talon',
  ANNOUNCEMENT: 'announcements',
  TRICK: 'tricks',
  FINISHED: 'finished',
}

const stageSections = {
  [stages.BID]: sections.BIDS,
  [stages.KING]: sections.KINGS,
  [stages.PICK_TALON]: sections.PICK_TALON,
  [stages.RESOLVE_TALON]: sections.RESOLVE_TALON,
  [stages.ANNOUNCEMENT]: sections.ANNOUNCEMENTS,
  [stages.TRICK]: sections.TRICKS,
  [stages.FINISHED]: sections.FINISHED,
}

function advanceStage() {
  const currentStage = getState(state.VISIBLE_STAGE);
  if (currentStage == stages.TRICK && !getState(stages.TRICK).finished) {
    advanceTricks();
  } else {
    const availableStages = getState(state.STAGES);
    const nextStage = availableStages[availableStages.indexOf(currentStage) + 1]

    console.log('availableStages', availableStages);
    console.log('setting stage to', nextStage);
    setState(state.VISIBLE_STAGE, nextStage);
    revealStageAndHideOthers(nextStage);
  }
}

function advanceTricks() {
  const currentTrickIndex = getState(state.VISIBLE_TRICK_INDEX);
  const newTrickIndex = currentTrickIndex + 1;
  setState(state.VISIBLE_TRICK_INDEX, newTrickIndex);
  revealTrickAndHideOthers(newTrickIndex);
}


function advanceAvailable() {
  const visibleStage = getState(state.VISIBLE_STAGE);

  if (getState(visibleStage).finished) {
    return true
  } else if (visibleStage == stages.TRICK) {
    return advanceTricksAvailable()
  } else {
    return false
  }
}

function advanceTricksAvailable() {
  const playableTrickIndex = getState(stages.TRICK).playable_trick_index
  const visibleTrickIndex = getState(state.VISIBLE_TRICK_INDEX);
  return visibleTrickIndex < playableTrickIndex
}

function revealStageAndHideOthers(stageToReveal) {
  Object.values(stages).forEach((stage) => {
    if (stage == stageToReveal) {
      revealStage(stage)
    } else {
      hideStage(stage);
    }
  })
}

function hideStage(stage) {
  $(stageSelector(stage)).addClass('d-none')
}

function revealStage(stage) {
  $(stageSelector(stage)).removeClass('d-none')
}


function stageSelector(stage) {
  return `#${stage}`
}


function nextVisibleStage() {
  switch (getState(state.VISIBLE_STAGE)) {
    case stages.BID:
      if (kingNeeded()) { return stages.KING }
      else if (talonCardsToPick()) { return stages.PICK_TALON }
      else { return stages.ANNOUNCEMENT }
    case stages.KING:
      if (talonCardsToPick()) { return stages.PICK_TALON }
      else { return stages.ANNOUNCEMENT }
    case stages.PICK_TALON:
      return stages.RESOLVE_TALON
    case stages.PICK_WHOLE_TALON:
      return stages.RESOLVE_WHOLE_TALON
    case stages.RESOLVE_TALON:
      return stages.ANNOUNCEMENT
    case stages.RESOLVE_WHOLE_TALON:
      return stages.ANNOUNCEMENT
    case stages.ANNOUNCEMENT:
      return stages.TRICK
    case stages.TRICK:
      return stages.FINISHED
  }
}
