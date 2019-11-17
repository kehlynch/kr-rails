// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require cable

function submitGame(checkbox) {
  if (checkbox) {
    $(checkbox).prop('checked', true)
  }
  document.getElementById('gameForm').submit();
}

function showScores() {
  document.getElementById('js-trick-container').style.display = 'none';
  document.getElementById('js-score-container').style.display = 'block';
  document.getElementById('js-points-container').style.display = 'none';
}

function showPoints() {
  document.getElementById('js-trick-container').style.display = 'none';
  document.getElementById('js-score-container').style.display = 'none';
  document.getElementById('js-points-container').style.display = 'block';
}

function attachClickers() {
  document.onclick = pageClicked;
}

function pageClicked() {
  const gameStage = stage();
  if ( gameStage == 'next_trick' || gameStage == 'pick_whole_talon') {
    document.getElementById('gameForm').submit();
  // } else if ( gameStage == 'finished') {
  //   showScores();
  } else if (!myMove()) {
    if ( gameStage == 'pick_talon' || gameStage == 'resolve_talon' || gameStage == 'pick_king' || gameStage == 'make_bid' || gameStage == 'play_card' || gameStage == 'make_announcement') {
      document.getElementById('gameForm').submit();
    }
  }
}

attachClickers()
