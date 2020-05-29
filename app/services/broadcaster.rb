class Broadcaster
  def initialize(game)
    @game = game
  end

  def broadcast
    p '***broadcasting'
    @game.reload
    @game.game_players.select(&:human?).each do |game_player|
      broadcast_to_player(game_player.player_id)
    end
  end

  def broadcast_to_player(player_id)
    data = GamePresenter.new(@game, player_id).props
    channel = "#{player_id}-#{@game.id}"
    ActionCable.server.broadcast(channel, data)
  end
end

