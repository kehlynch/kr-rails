class Broadcaster
  def initialize(game)
    @game = game
  end

  def broadcast(visible_stage=nil)
    @game.players.select(&:human?).each do |player|
      broadcast_to_player(player.id, visible_stage)
    end
  end

  def broadcast_to_player(player_id, visible_stage=nil)
    data = GamePresenter.new(@game, player_id).props(visible_stage)
    channel = "#{player_id}-#{@game.id}"
    ActionCable.server.broadcast(channel, data)
  end
end

