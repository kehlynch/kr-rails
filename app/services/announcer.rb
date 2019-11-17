module Announcer
  def announce(game, **params)
    MessagesChannel.broadcast_to(game, **params)
  end

  def announce_player(player, **params)
    PlayersChannel.broadcast_to(player, **params)
  end
end
