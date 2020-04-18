function changeStage(stage) {
  setState('stage', stage);
  $('#js-stage').attr('value', stage);
  if (stage == 'pick_king') {
    hideBidPicker();
    revealKings();
  }
  if (stage == 'pick_whole_talon') {
    showPickWholeTalon();
  }
  if (stage == 'pick_talon') {
    showPickTalon();
  }
  if (stage == 'resolve_talon') {
    showResolveTalon();
  }
  if (stage == 'resolve_whole_talon') {
    showResolveWholeTalon();
  }
  if (stage == 'make_announcement') {
    showAnnouncementsPicker();
    // $('#talon-submit').addClass('d-none');
    // $("#js-valid-bids").addClass("d-none");
    // hideKings();
    // hideTalon();
  }

  if (stage == 'play_card') {
    reveal(sections.TRICK);
    hideBidPicker();
    hideAnnouncementPicker();
    hideKings();
    hideTalon();
  }

  if (stage == 'finished') {
    hide(sections.TRICK);
    reveal(sections.FINISHED_BUTTONS);
    showScores();
  }
  setInProgress(false);
}
