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
      if (data.remarks) {
        console.log('data.speech')
        Object.entries(data.remarks).forEach(([playerPosition, remark]) => {
          addRemark(playerPosition, remark);
        })
      }

      if (data.player_id == playerId()) {
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
        if (data.won_card) {
          setWonCard(data.won_card)
        }
      }

      if (action == 'info') {
        setNextPlayer(data.next_player);
        changeStage(data.stage);
        setState('current-trick', data.playable_trick_index);
      }
    },
  });

  // for refreshing show page
  const showPageMatchId = $('#js-reload-on-match-ready').attr('data-match-id');
  const showPagePlayerId = $('#js-reload-on-match-ready').attr('data-player-id');
  if (showPageMatchId) {
    App.matchMessages = App.cable.subscriptions.create({channel: 'MatchesChannel', id:  showPageMatchId}, {  
      received: function(data) {
        // console.log("recvd from match channel", data);
        // for when a new human joins
        const url = `/matches/${showPageMatchId}/players/${showPagePlayerId}/games/${data.game_id}/edit`
        window.location.href = url;
      },
    });
  }
}

$(document).ready(function() {
  scrollMessageBox();
  createSubscriptions();
})
