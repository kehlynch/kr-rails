//= require_tree .
//= require jquery3

function addKing(slug) {
  $("#js-king").append(`<img alt="diamond_8" class="kr-card " src="/assets/${slug}.jpg">`)
}

function createSubscriptions() {
  this.App = {};
  App.cable = ActionCable.createConsumer();  
  App.messages = App.cable.subscriptions.create({channel: 'MessagesChannel', id: gameId()}, {  
    received: function(data) {
      console.log("recvd from messages channel", data);
      const action = data.action;

      if (data.message) {
        addMessage(data.message);
      }
      if (data.player_id == playerId()) {
        console.log("adding player info", data);
        addPlayerInfo(data)
      }

      if (action == 'bid') {
        addBid(data.bid, data.player)
      }
      if (action == 'bid_won') {
        setWonBid(data.slug, data.declarer)
      }
      if (action == 'king') {
        addKing(data.king_slug)
      }
      if (action == 'talon') {
        showPickedTalon(data.talon_half_index)
      }
      if (action == 'announcement') {
        addAnnouncement(data.announcement, data.player)
        addPlayerInfo(data)
      }
      if (action == 'play_card') {
        addTrickCard(data.card_slug, data.trick_index, data.player)
      }

      if (action == 'info') {
        setNextPlayer(data.next_player);
        changeStage(data.stage);
        setState('current-trick', data.current_trick_index);
      }
    },
  });

  // App.playerMessages = App.cable.subscriptions.create({channel: 'PlayersChannel', player_id: playerId(), game_id: gameId()}, {
  //   received: function(data) {
  //     console.log("recvd from player channel", data);
  //     addPlayerInfo(data)
  //   },
  // });

  // for refreshing show page
  const showPageMatchId = $('#js-reload-on-match-ready').attr('data-match-id');
  const showPagePlayerId = $('#js-reload-on-match-ready').attr('data-player-id');
  if (showPageMatchId) {
    console.log("subscribing to match channel");
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
  console.log("document ready");
  scrollMessageBox();
  createSubscriptions();
})
