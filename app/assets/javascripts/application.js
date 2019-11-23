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
  if (checkbox) { $(checkbox).prop('checked', true) }
  document.getElementById('gameForm').submit();
}

function nextHand() {
  const url = `/matches/${matchId()}/players/${playerId()}/games/${gameId()}/next`
  const csrf_token = $('meta[name="csrf-token"]').attr('content');
  const csrf_input = `<input type="hidden" name="authenticity_token" value=${csrf_token} />`
  const form = `<form action=${url} method="post">${csrf_input}</form>`
  $(form).appendTo('body').submit(); 
}

function showScores() {
  $('#js-score-container').removeClass('d-none');
  $('#js-points-container').addClass('d-none');
}

function showPoints() {
  $('#js-points-container').removeClass('d-none');
  $('#js-score-container').addClass('d-none');
}

function attachClickers() {
  document.onclick = pageClicked;
}

function pageClicked() {
  const gameStage = stage();
  
  console.log("pageClicked()", gameStage, myMove());
  if (gameStage == 'play_card') {
    if (myMove()) {
      revealTrick(currentTrickIndex());
    } else {
      // just to start the first trick if we're not declarer
      $('#gameForm').submit();
    }
  } else if (gameStage == 'pick_whole_talon') {
    $('#gameForm').submit();
  } else if (gameStage && !myMove() && gameStage != 'finished') {
    $('#gameForm').submit();
  }
}

attachClickers()
