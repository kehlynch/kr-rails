//= require_tree .
//= require jquery3

function addKing(slug) {
  $("#js-king").append(`<img alt="diamond_8" class="kr-card " src="/assets/${slug}.jpg">`)
}

function createSubscriptions() {
  console.log("createSubscriptions", gameId(), playerId());
  this.App = {};
  App.cable = ActionCable.createConsumer();  
  App.messages = App.cable.subscriptions.create({channel: 'MessagesChannel', id: gameId()}, {  
    received: function(data) {
      console.log("recvd from messages channel", data);
      const action = data.action;

      if (data.message) {
        addMessage(data.message);
      }

      if (data.instruction) {
        $('#instruction').empty()
        $('#instruction').append(data.instruction);
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
      }
      if (action == 'play_card') {
        addTrickCard(data.card_slug, data.trick_index, data.player)
      }
      if (action == 'score') {
        addScores(data.scores)
        addGameSummaries(data.game_summaries)
      }

      if (action == 'info') {
        setNextPlayer(data.next_player);
        changeStage(data.stage);
        setState('current-trick', data.current_trick_index);
      }
    },
  });

  App.messages = App.cable.subscriptions.create({channel: 'PlayersChannel', id: playerId()}, {  
    received: function(data) {
      console.log("recvd from player channel", data);
      addPlayerInfo(data)
    },
  });
}

$(document).ready(function() {
  console.log("document ready");
  scrollMessageBox();
  createSubscriptions();
})
