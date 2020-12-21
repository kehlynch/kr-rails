class GameChannel < ApplicationCable::Channel
	def subscribed
    p 'connect to games channel', params[:id]
    @game = Game.find(params[:id])
    stream_for @game
	end

  def received(data)
    p 'gamechannel received', data
    GameChannel.broadcast_to(@game, data)

  end
end
