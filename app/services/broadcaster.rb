class Broadcaster
  def initialize(game, active_player_id)
    @game = game
    @message = MessagePresenter.new(game)
    @active_player_id = active_player_id
  end

  def broadcast_to_humans(data)
    @game.players.select(&:human?).each do |player|
      channel = "#{player.id}-#{@game.id}"
      ActionCable.server.broadcast(channel, data)
    end
  end

  def bid(bid:)
    data = GamePresenter.new(@game, @active_player_id)
      .props
      .merge(change: 'bid_made')

    broadcast_to_humans(data)
    # broadcaster = Broadcasters::BidBroadcaster.new(@game, bid)
    # broadcast_to_humans(broadcaster)
  end
end

