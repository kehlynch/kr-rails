function changeStage(stage) {
  console.log('changeStage', stage);
  setState('stage', stage);
  $('#js-stage').attr('value', stage);
  if (stage == 'make_bid') {
    if (myMove()) {
      $("#js-valid-bids").removeClass("d-none");
    }
  }
  if (stage == 'pick_king') {
    $("#js-valid-bids").addClass("d-none");
    $("#js-kings").removeClass("d-none");
    if (myMove()) {
      $("#js-kings").find("img").addClass("pickable");
    } else {
      $("#js-kings").find("img").removeClass("pickable");
    }
  }
  if (stage == 'pick_talon') {
    $("#js-valid-bids").addClass("d-none");
    $("#js-kings").addClass("d-none");
    $("#js-talon").removeClass("d-none");
    if (myMove()) {
      $("#js-talon").children("div").addClass("pickable");
      $("#js-talon-half-0").attr("onclick", 'submitGame(talon_0)')
      $("#js-talon-half-1").attr("onclick", 'submitGame(talon_1)')
    }
  }
  if (stage == 'resolve_talon') {
    $("#js-valid-bids").addClass("d-none");
    $("#js-kings").addClass("d-none");
    if (myMove()) {
      $("#js-talon").addClass("d-none");
    }
  }
  if (stage == 'make_announcement') {
    $('#talon-submit').addClass('d-none');
    $("#js-valid-bids").addClass("d-none");
    $("#js-kings").addClass("d-none");
    $("#js-talon").addClass("d-none");
    if (myMove) {
      $("#js-valid-announcements").removeClass("d-none");
    }
  }

  if (stage == 'play_card') {
    removeAnnouncements;
    $("#js-tricks").removeClass("d-none");
    $("#js-valid-announcements").addClass("d-none");
    $("#js-valid-bids").addClass("d-none");
    $("#js-kings").addClass("d-none");
    $("#js-talon").addClass("d-none");
  }

  if (stage == 'finished') {
    $("#js-tricks").addClass("d-none");
    $("#js-finished-buttons").removeClass("d-none");
    showHandScores();
  }
}
