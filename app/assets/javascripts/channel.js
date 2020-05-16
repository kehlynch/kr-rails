//= require_tree .
//= require jquery3

function createSubscriptions() {
  this.App = {};
  const channel = getState(state.CHANNEL);
  App.cable = ActionCable.createConsumer();  
  console.log(`connecting to ${channel}`);
  App.messages = App.cable.subscriptions.create(channel, {
    received: function(data) {
      console.log("recvd from players channel", data, data.players[0].bids);
      applyChange(data);
      // addBid(data.bid);
      // setNextPlayer(data.game.next_player);
      // addPlayerInfo(data.player);
    }
  })

  // // for refreshing show page
  // const showPageMatchId = $('#js-reload-on-match-ready').attr('data-match-id');
  // const showPagePlayerId = $('#js-reload-on-match-ready').attr('data-player-id');
  // if (showPageMatchId) {
  //   App.matchMessages = App.cable.subscriptions.create({channel: 'MatchesChannel', id:  showPageMatchId}, {
  //     received: function(data) {
  //       // console.log("recvd from match channel", data);
  //       // for when a new human joins
  //       const url = `/matches/${showPageMatchId}/players/${showPagePlayerId}/games/${data.game_id}/edit`
  //       window.location.href = url;
  //     },
  //   });
  // }
}

$(document).ready(function() {
  console.log("hello");
  createSubscriptions();
})

