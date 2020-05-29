//= require_tree .
//= require jquery3

function createSubscriptions() {
  this.App = {};
  App.cable = ActionCable.createConsumer();  
  const channel = getState(state.CHANNEL);
  if (channel) {
    App.messages = App.cable.subscriptions.create(channel, {
      received: function(data) {
        console.log("recvd from players channel", data);
        applyChange(data);
      }
    })
  }

  // for refreshing show page
  const showPageMatchId = $('#js-reload-on-match-ready').attr('data-match-id');
  const showPagePlayerId = $('#js-reload-on-match-ready').attr('data-player-id');
  if (showPageMatchId) {
    App.matchMessages = App.cable.subscriptions.create({channel: 'MatchesChannel', id:  showPageMatchId}, {
      received: function(data) {
        console.log("recvd from match channel", data);
        // for when a new human joins
        const url = `/matches/${showPageMatchId}/players/${showPagePlayerId}/games/${data.game_id}/edit`
        window.location.href = url;
      },
    });
  }
}

$(document).ready(function() {
  createSubscriptions();
})

