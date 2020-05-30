function submitGame(checkbox) {
  if (checkbox) { $(checkbox).prop('checked', true); }
  document.getElementById('gameForm').submit();
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
