function changeStage(stage) {
  setState('stage', stage);
  $('#js-stage').attr('value', stage);
  if (stage == 'pick_king') {
    $("#js-valid-bids").addClass("d-none");
    $("#js-kings").removeClass("d-none");
  }
  if (stage == 'pick_whole_talon') {
    enablePickWholeTalon();
  }
  if (stage == 'pick_talon') {
    enablePickTalon();
  }
  if (stage == 'resolve_talon') {
    enableResolveTalon();
  }
  if (stage == 'resolve_whole_talon') {
    enableResolveWholeTalon();
  }
  if (stage == 'make_announcement') {
    $('#talon-submit').addClass('d-none');
    $("#js-valid-bids").addClass("d-none");
    $("#js-kings").addClass("d-none");
    $("#js-talon").addClass("d-none");
  }

  if (stage == 'play_card') {
    // removeAnnouncements();
    $("#js-tricks").removeClass("d-none");
    $("#js-valid-bids").addClass("d-none");
    $("#js-valid-announcements").addClass("d-none");
    $("#js-kings").addClass("d-none");
    $("#js-talon").addClass("d-none");
  }

  if (stage == 'finished') {
    $("#js-tricks").addClass("d-none");
    $("#js-finished-buttons").removeClass("d-none");
    showScores();
  }
  setInProgress(false);
}
