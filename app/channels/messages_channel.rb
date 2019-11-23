class MessagesChannel < ApplicationCable::Channel
	def subscribed
    game = Game.find(params[:id])
    stream_for game
	end

	def receive
		ActionCable.server.broadcast(match_channel, message: 'message received!', head: :ok)
	end
end
