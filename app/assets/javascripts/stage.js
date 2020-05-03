const stages = {
  BID: 'make_bid',
  KING: 'pick_king',
  PICK_TALON: 'pick_talon',
  PICK_WHOLE_TALON: 'pick_whole_talon',
  RESOLVE_TALON: 'resolve_talon',
  RESOLVE_WHOLE_TALON: 'resolve_whole_talon',
  ANNOUNCEMENT: 'make_announcement',
  TRICK: 'play_card',
  FINISHED: 'finished',
}

function stage() { return getState(state.ACTION); }

function setStage() { setState(newState.ACTION, stage); }

function changeStage(stage) {
  setStage(stage);
  if (stage == 'pick_king') {
    setState('visible-stage', 'pick_king');
    hideBidPicker();
    revealKings();
    addKingMessage();
  }
  if (stage == 'pick_talon') {
    if (myMove()) {
      setState('visible-stage', 'pick_talon');
      showPickTalon();
    }
  }
  if (stage == 'pick_whole_talon') {
    if (myMove()) {
      setState('visible-stage', 'pick_whole_talon');
      showPickWholeTalon();
    }
  }
  if (stage == 'resolve_talon') {
    if (myMove()) {
      setState('visible-stage', 'resolve_talon');
      showResolveTalon();
    }
  }
  if (stage == 'resolve_whole_talon') {
    if (myMove()) {
      setState('visible-stage', 'resolve_whole_talon');
      showResolveWholeTalon();
    }
  }
  if (stage == 'make_announcement') {
    if (myMove()) {
      setState('visible-stage', 'announcements');
      showAnnouncementsPicker();
    }
    // $('#talon-submit').addClass('d-none');
    // $("#js-valid-bids").addClass("d-none");
    // hideKings();
    // hideTalon();
  }

  if (stage == 'play_card') {
    setState('visible-stage', 'play_card');
    reveal(sections.TRICK);
    hideBidPicker();
    hideAnnouncementPicker();
    hideKings();
    hideTalon();
  }

  if (stage == 'finished') {
    setState('visible-stage', 'finished');
    hide(sections.TRICK);
    reveal(sections.FINISHED_BUTTONS);
    showScores();
  }
  setInProgress(false);
}

function nextVisibleStage() {
  switch (visibleStage()) {
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

function advanceVisibleStage() {
  switch (nextVisibleStage()) {
    case stages.KING:
      hide(sections.BID_PICKER);
      reveal(sections.KINGS);
      setKingsPickable(isDeclarer());
      setInstruction(isDeclarer() ? 'pick a king' : `${declarerName()} to pick a king`);
      break;
    case stages.PICK_TALON:
      hide(sections.KINGS);
      reveal(sections.TALON);
      setTalonPickable(isDeclarer());
      break;
    case stages.PICK_WHOLE_TALON:
      hide(sections.KINGS);
      reveal(sections.TALON);
      setTalonPickable(isDeclarer());
      break;
    case stages.RESOLVE_TALON:
      if (isDeclarer()) {
        hide(sections.KINGS);
        setTalonResolvable(isDeclarer());
      }
      break;
    case stages.RESOLVE_WHOLE_TALON:
      if (isDeclarer()) {
        hide(sections.KINGS);
        setTalonResolvable(isDeclarer());
      }
      break;
    case stages.ANNOUNCEMENT:
      hide(sections.TALON);
      hide(sections.KING);
      reveal(sections.ANNOUNCEMENT_PICKER);
      setAnnouncementsMessage();
      break;

    case stages.TRICK:
      hide(sections.ANNOUNCEMENT_PICKER);
      reveal(sections.TRICK);
  }

  setVisibleStage(nextVisibleStage());

  // console.log("advancePreAnnouncements", visibleStage(), talonPicked());
  // if (visibleStage() == 'pick_king' && talonPicked()) {
  //   console.log("advancePreAnnouncements, advancing from King");
  //   hideKings();
  //   revealTalon();
  //   setTalonMessage();
  //   setState('visible-stage', 'talon');
  // } else if (visibleStage() == 'pick_king') {
  //   hideKings();
  //   showAnnouncementsPicker();
  //   setAnnouncementsMessage();
  //   setState('visible-stage', 'announcements');
  // } else if (['pick_talon', 'pick_whole_talon', 'resolve_talon', 'resolve_whole_talon'].includes(visibleStage())) {
  //   hideTalon();
  //   shownAnnouncementsPicker();
  //   setAnnouncementsMessage();
  //   setState('visible-stage', 'announcements');
  // }
}

function setVisibleStage(stage) {
  setState('visible-stage', stage);
}
