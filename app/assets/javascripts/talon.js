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

function showPickedTalon(index) {
  $(`#js-talon-half-${index}`).addClass("picked");
}

function showResolveTalon() {
  hideBidPicker();
  hideKings();
}

function showResolveWholeTalon() {
  hideBidPicker();
  hideKings();
}

function showPickTalon() {
  hideBidPicker();
  hideKings();
  revealTalon();
}

function showPickWholeTalon() {
  hideBidPicker();
  hideKings();
  revealTalon();
}

function setTalonPickable(pickable=true) {
  if (pickable) {
    sectionElement(sections.TALON).children('div').addClass('pickable');
    $('#js-talon-half-0').attr('onclick', 'submitGame(talon_0)')
    $('#js-talon-half-1').attr('onclick', 'submitGame(talon_1)')
  } else {
    sectionElement(sections.TALON).children('div').removeClass('pickable');
  }
}

function setTalonResolvable(resolvable) {
  if (resolvable) {
    hideTalon();
    makeHandPickable();
  }
}

function showTalonGameEnd() {
  hide(sections.SCORES_CONTAINER)
  hide(sections.POINTS_CONTAINER)
  revealTalon();
}

function revealTalon() {
  reveal(sections.TALON)
}

function hideTalon() {
  hide(sections.TALON);
}

function revealResolveTalonButton() {
  reveal(sections.SUBMIT_TALON);
}

function hideResolveTalonButton() {
  hide(sections.SUBMIT_TALON);
}

function setTalonMessage() {
  if ( !talonToCardsPick() ) {
    return
  } else if ( talonCardsToPick() == 6 ) {
    return setFullTalonMessage()
  } else {
    if ( myMove() ) {
      setInstruction('Pick 3 cards to put down');
    } else {
      // TODO get the half with talonPicked() and ordinalise
      setInstruction(`${declarerName()} picks talon`);
    }
  }
}

function setFullTalonMessage() {
  if ( myMove() ) {
    setInstruction('Click to take whole talon');
  } else {
    // TODO get the half with talonPicked() and ordinalise
    setInstruction(`${declarerName()} takes whole talon`);
  }
}


