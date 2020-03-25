function toggleCard(checkbox) {
  checkbox.checked = !checkbox.checked;
  checkbox.nextElementSibling.classList.toggle('selected');
  var selected = $("#js-hand").find('input[type="checkbox"]:checked').length;
  var submitButton = document.getElementById('talon-submit')
  if (stage() == 'resolve_talon') {
    submitButton.disabled = selected != 3;
  } else if (stage() == 'resolve_whole_talon') {
    submitButton.disabled = selected != 6;
  }
}

function revealResolveTalonButton() {
  $('#talon-submit').removeClass('d-none');
}

function showPickedTalon(index) {
  $(`#js-talon-half-${index}`).addClass("picked");
}

function enableResolveTalon() {
  $("#js-valid-bids").addClass("d-none");
  $("#js-kings").addClass("d-none");
}

function enableResolveWholeTalon() {
  $("#js-valid-bids").addClass("d-none");
  $("#js-kings").addClass("d-none");
}

function enablePickTalon() {
  $("#js-valid-bids").addClass("d-none");
  $("#js-kings").addClass("d-none");
  $("#js-talon").removeClass("d-none");
}

function enablePickWholeTalon() {
  $("#js-valid-bids").addClass("d-none");
  $("#js-kings").addClass("d-none");
  $("#js-talon").removeClass("d-none");
}

function setTalonPickable(pickable) {
  if (pickable) {
    $('#js-talon').children('div').addClass('pickable');
    $('#js-talon-half-0').attr('onclick', 'submitGame(talon_0)')
    $('#js-talon-half-1').attr('onclick', 'submitGame(talon_1)')
  } else {
    $('#js-talon').children('div').removeClass('pickable');
  }
}

function setTalonResolvable(resolvable) {
  if (resolvable) {
    $("#js-talon").addClass("d-none");
    makeHandPickable();
  }
}

function showTalonGameEnd() {
  $('#js-score-container').addClass('d-none');
  $('#js-points-container').addClass('d-none');
  $("#js-talon").removeClass("d-none");
}

