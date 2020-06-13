function submitGame(checkbox) {
  if (checkbox) { $(checkbox).prop('checked', true); }
  const url = $('#gameForm').attr('action');
  $.ajax({
    type: "POST",
    url: url,
    data: $('#gameForm').serialize(), // serializes the form's elements.
  });

  const currentStage = getState(state.VISIBLE_STAGE);
  console.log('submitGame', currentStage);
  if ([stages.KING, stages.PICK_TALON, stages.RESOLVE_TALON].includes(currentStage)) {
    advanceStage();
  }
  // stop safari reloading?
  return false
}

function attachClickers() {
  if (stateExists()) {
    document.onclick = advance;
    document.body.onkeyup = function(e){
      if(e.keyCode == 32){
          advance();
      }
    }
  }
}

function advance() {
  if (advanceAvailable()) {
    advanceStage();
  }
}

$(document).ready(function() {
  attachClickers();
})
