function submitGame(checkbox) {
  console.log('submitGame');
  if (checkbox) { $(checkbox).prop('checked', true); }
  document.getElementById('gameForm').submit();
  if (![stages.BID, stage.ANNOUNCEMENTS].includes(stage())) {
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
  console.log("advance?")
  if (advanceAvailable()) {
    console.log("advancing!")
    advanceStage();
  }
}

$(document).ready(function() {
  attachClickers();
})
