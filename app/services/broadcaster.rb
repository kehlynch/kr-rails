class Broadcaster
  def initialize(game)
    # @game = game
  end

  def broadcast(game)
    p '***broadcasting'
    game.game_players.select(&:human?).each do |game_player|
      broadcast_to_player(game, game_player.player_id)
    end
  end

  def broadcast_to_player(game, player_id)
    data = GamePresenter.new(game, player_id).props
    channel = "#{player_id}-#{game.id}"
    ActionCable.server.broadcast(channel, data)
  end
end

