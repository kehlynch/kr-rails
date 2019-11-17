//= require_tree .
//= require jquery3

function addPlayerInfo(data) {
  if (data.valid_bids) {
    data.valid_bids.forEach(addValidBid)
  } else if (data.valid_announcements) {
    addValidAnnouncements(data.valid_announcements);
  } else if (data.hand) {
    updateHand(data.hand);
  }
}

function addKing(slug) {
  $("#js-king").append(`<img alt="diamond_8" class="kr-card " src="/assets/${slug}.jpg">`)
}

function showPickedTalon(index) {
  $(`#js-talon-half-${index}`).addClass("picked");
}

function createSubscriptions() {
  this.App = {};
  App.cable = ActionCable.createConsumer();  
  App.messages = App.cable.subscriptions.create({channel: 'MessagesChannel', id: gameId()}, {  
    received: function(data) {
      console.log("recvd from messages channel", data);
      const action = data.action;

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
        addTrickCard(data.card_slug, data.player)
      }

      if (action == 'info') {
        setNextPlayer(data.next_player);
        changeStage(data.stage);
        addMessage(data.message);
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
  scrollMessageBox();
  createSubscriptions();
})
