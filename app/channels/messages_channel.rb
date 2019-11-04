class MessagesChannel < ApplicationCable::Channel
	def subscribed
		stream_from match_channel
	end

	def receive
    p '***'
    p "broadcastingon #{match_channel}"
		ActionCable.server.broadcast(match_channel, message: 'message received!', head: :ok)
	end

  private

  def match_channel
    "MessageChannel"
    # "MessageChannel_#{params[:match_id]}"
  end
end
