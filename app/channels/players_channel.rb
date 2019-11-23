class PlayersChannel < ApplicationCable::Channel
	def subscribed
    stream_from "#{params[:player_id]}-#{params[:game_id]}"
	end
end
