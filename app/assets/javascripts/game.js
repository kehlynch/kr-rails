function submitGame(checkbox) {
  if (checkbox) { $(checkbox).prop('checked', true); }
  document.getElementById('gameForm').submit();

  const currentStage = getState(state.VISIBLE_STAGE);
  if ([stages.KING, stages.PICK_TALON, stages.RESOLVE_TALON].includes(currentStage)) {
    advanceStage();
  }
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
