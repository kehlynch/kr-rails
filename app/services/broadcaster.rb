class Broadcaster
  def initialize(game)
    @game = game
  end

  def broadcast(visible_stage=nil)
    @game.reload
    @game.game_players.select(&:human?).each do |game_player|
      broadcast_to_player(game_player.player_id, visible_stage)
    end
  end

  def broadcast_to_player(player_id, visible_stage=nil)
    # data = GamePresenter.new(@game, player_id).props(visible_stage)
    data = {}
    channel = "#{player_id}-#{@game.id}"
    ActionCable.server.broadcast(channel, data)
  end
end

