module Broadcasters
  class BidBroadcaster
    def initialize(game, bid)
      @game = game
      @bid = bid
      @message = MessagePresenter.new(game)
    end

    def broadcast_to(channel, player)
      ActionCable.server.broadcast(
        channel,
        params(player)
      )
    end

    private 

    def params(player)
      {
        bid: bid_params,
        player: player_params(player),
        game: game_params
      }
    end

    def bid_params
      {
        action: 'bid',
        player: bid_player_params(@bid.player),
        slug: @bid.slug,
        message: @message.bid_msg(@bid),
        finished: @game.bids.finished?
      }
    end

    def bid_player_params(player)
      {
        position: player.position,
        name: player.name
      }
    end

    def game_params
      {
        next_player: @game.next_player&.position,
        playable_trick_index: @game.tricks.playable_trick_index,
        stage: @game.stage
      }
    end

    def player_params(player)
      params = {}
      my_move = @game.next_player&.id == player.id
      params[:my_move] = my_move

      if @game.partner_known_by?(player.id)
        partner = @game.partner ? @game.partner.position : 'talon'
        params[:partner] = partner
      end

      if my_move
        case @game.stage
          when 'make_bid'
            params[:valid_bids] = @game.bids.valid_bids
          when 'make_announcement'
            params[:valid_announcements] = @game.announcements.valid_announcements
        end
      end

      params[:pick_king] = my_move if @game.stage == 'pick_king'
      params[:pick_talon] = my_move if @game.stage == 'pick_talon'
      params[:resolve_talon] = my_move if ['resolve_talon', 'resolve_whole_talon'].include?(@game.stage)

      if ['play_card', 'resolve_talon', 'resolve_whole_talon', 'make_announcement', 'finished'].include?(@game.stage)
        game_player = GamePlayer.new(player, @game)
        hand = HandPresenter.new(game_player.hand).sorted.map { |c| {slug: c.slug, legal: c.legal?} }
        params[:hand] = hand
      end

      return params
    end
  end
end
