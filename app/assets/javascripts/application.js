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
  if (checkbox) { $(checkbox).prop('checked', true); }
  document.getElementById('gameForm').submit();
}

function showScores() {
  hide(sections.TALON);
  hide(sections.POINTS_CONTAINER);
  reveal(sections.SCORES_CONTAINER);
}

function showPoints() {
  hide(sections.TALON);
  hide(sections.SCORES_CONTAINER);
  reveal(sections.POINTS_CONTAINER);
}

function attachClickers() {
  document.onclick = pageClicked;
}

function pageClicked() {
  const gameStage = stage();

  if (inProgress()) { return; }

  if (continueAvailable()) {
    if (gameStage == 'play_card' && currentTrickIndex() !== visibleTrickIndex()) {
      revealTrick(currentTrickIndex());
      setContinueAvailable(false);
    } else {
      advanceVisibleStage();
      setContinueAvailable(false);
    }
  }
}

attachClickers();
