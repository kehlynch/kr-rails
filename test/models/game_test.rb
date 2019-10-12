require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'creates a new game' do
    game = Game.new
    p game.cards
    # assert game.talon.cards.length == 2
    # assert game.bidding.contract.nil?
    # assert game.tricks.length.empty?
    # assert game.players.length == 4
  end
end
