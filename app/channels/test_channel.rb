class TestChannel < ApplicationCable::Channel
	def subscribed
    p 'SUBSCRIBING TO TEST CHANNEL'
    stream_from "test"
	end
end
