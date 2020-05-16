function submitGame(checkbox) {
  if (checkbox) { $(checkbox).prop('checked', true); }
  document.getElementById('gameForm').submit();
}

function attachClickers() {
  console.log("attachClickers");
  document.onclick = advance;
  document.body.onkeyup = function(e){
    if(e.keyCode == 32){
        advance();
    }
  }
}

function advance() {
  console.log("page clicked")
  if (advanceAvailable()) {
    advanceStage();
  }
}

$(document).ready(function() {
  console.log("game running");

  attachClickers();
})
