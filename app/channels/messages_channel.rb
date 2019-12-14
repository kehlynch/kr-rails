class MessagesChannel < ApplicationCable::Channel
	def subscribed
    if (params[:id])
      game = Game.find(params[:id])
      stream_for game
    end
	end

	def receive
		ActionCable.server.broadcast(match_channel, message: 'message received!', head: :ok)
	end
end
