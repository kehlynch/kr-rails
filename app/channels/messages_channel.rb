class MessagesChannel < ApplicationCable::Channel
	def subscribed
    if (params[:id])
      game = Game.find(params[:id])
      stream_for game
    end
	end
end
