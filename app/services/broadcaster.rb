class Broadcaster
  class << self
    def broadcast(game)
      # p '***broadcasting'
      # # reload the game with associations
      # game = Game.with_associations.find(unrefreshed_game.id)
      # game.game_players.select(&:human?).each do |game_player|
      #   broadcast_to_player(game, game_player.player_id)
      # end
      # GameChannel.broadcast_to(game, game)
      GameChannel.broadcast_to(game, ActiveModelSerializers::SerializableResource.new(game, serializer: GameSerializer, key_transform: :camel_lower))
    end

    private

    def broadcast_to_player(game, player_id)
      # data = GamePresenter.new(game, player_id).props
      data = {test: true}
      channel = "#{player_id}-#{game.id}"
      ActionCable.server.broadcast(channel, data)
    end
  end
end
