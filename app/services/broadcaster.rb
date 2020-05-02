class Broadcaster
  def initialize(game)
    @game = game
    @message = MessagePresenter.new(game)
  end

  def broadcast_to_humans(broadcaster)
    @game.players.select(&:human?).each do |player|
      channel = "#{player.id}-#{@game.id}"
      broadcaster.broadcast_to(channel, player)
    end
  end

  def bid(bid:)
    broadcaster = Broadcasters::BidBroadcaster.new(@game, bid)
    broadcast_to_humans(broadcaster)
  end

  # def bids_finished
  #   MessagesChannel.broadcast_to(
  #     @game,
  #     action: 'bid_won',
  #     slug: @game.bids.highest.slug,
  #     declarer: @game.declarer.position,
  #     message: @message.bids_finished_msg,
  #     stage: @game.stage,
  #     next_player: @game.next_player&.position,
  #     playable_trick_index: @game.tricks.playable_trick_index
  #   )
  #   players_info()
  # end

  def king_picked
    MessagesChannel.broadcast_to(
      @game,
      action: 'king',
      king_slug: @game.king,
      message: @message.king_picked_msg,
      stage: @game.stage,
      next_player: @game.next_player&.position,
      playable_trick_index: @game.tricks.playable_trick_index
    )
    players_info()
  end

  def talon_picked
    MessagesChannel.broadcast_to(
      @game,
      action: 'talon',
      talon_half_index: @game.talon_picked,
      message: @message.talon_picked_msg,
      stage: @game.stage,
      next_player: @game.next_player&.position,
      playable_trick_index: @game.tricks.playable_trick_index
    )
    players_info()
  end

  def talon_resolved
    MessagesChannel.broadcast_to(
      @game,
      action: 'resolve_talon',
      talon_half_index: @game.talon_picked,
      message: @message.talon_resolved_msg,
      stage: @game.stage,
      next_player: @game.next_player&.position,
      playable_trick_index: @game.tricks.playable_trick_index
    )
    players_info()
  end

  def announcement(announcement:)
    MessagesChannel.broadcast_to(
      @game,
      action: 'announcement',
      player: announcement.player.position,
      announcement: announcement.slug,
      message: @message.announcement_msg(announcement),
      stage: @game.stage,
      next_player: @game.next_player&.position,
      playable_trick_index: @game.tricks.playable_trick_index
    )
    players_info()
  end

  def announcements_finished
    MessagesChannel.broadcast_to(
      @game,
      message: @message.first_trick_msg,
      stage: @game.stage,
      next_player: @game.next_player&.position,
      playable_trick_index: @game.tricks.playable_trick_index
    )
    players_info()
  end

  def card_played(card:)
    MessagesChannel.broadcast_to(
      @game,
      action: 'play_card',
      player: card.player.position,
      card_slug: card.slug,
      trick_index: card.trick.trick_index,
      message: @message.trick_msg(card.trick),
      won_card: card.trick.won_card&.slug,
      stage: @game.stage,
      next_player: @game.next_player&.position,
      playable_trick_index: @game.tricks.playable_trick_index
    )
    players_info()
  end

  def players_info
    @game.reload

    @game.players.select(&:human?).each do |player|
      player_info(player)
    end
  end

  def player_info(player)
    params = {}
    my_move = @game.next_player&.id == player.id
    params[:my_move] = my_move
    params[:instruction] = @message.instruction_msg(player)

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
    broadcast_to_player(
      player,
      **params
    )
  end

  def make_remarks
    remarks = Remarks.remarks_for(@game)
    return if remarks.empty?

    MessagesChannel.broadcast_to(
      @game,
      remarks: remarks
    )
  end

  def scores
    @game.players.select(&:human?).each do |player|
      scores = PlayersPresenter.new(@game, player.id).map do |p|
        {
          name: p.name,
          won_tricks_count: p.won_tricks_count,
          points: p.points,
          team_points: p.team_points,
          game_points: p.game_points,
          winner: p.winner?
        }
      end

      game_summaries = MatchPresenter.new(@game.match, player.id).games.select(&:finished?).map(&:summary)

      broadcast_to_player(
        player,
        scores: scores,
        game_summaries: game_summaries
      )
    end
  end

  def broadcast_to_player(player, **params)
    MessagesChannel.broadcast_to(
      @game,
      player_id: player.id,
      **params
    )
  end
end

