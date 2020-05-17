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
  console.log('advance()');
  if (advanceAvailable()) {
    console.log('advancing stage');
    advanceStage();
  }
}

$(document).ready(function() {
  attachClickers();
})
