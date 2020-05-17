function toggleCard(checkboxId, requiredCount) {
  console.log('toggleCard', checkboxId, requiredCount);
  const checkbox = $(`#${checkboxId}`)
  checkbox.prop('checked', !checkbox.prop('checked'));
  checkbox.next().toggleClass('picked');
  const selectedCount = $("#js-resolve-talon-hand").find('input[type="checkbox"]:checked').length;
  var submitButton = document.getElementById('talon-submit')
  submitButton.disabled = selectedCount != requiredCount;
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
