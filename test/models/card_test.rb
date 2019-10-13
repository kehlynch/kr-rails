require 'test_helper'

class CardTest < ActiveSupport::TestCase
  test 'creates a new card' do
    game = Game.new
    card = Card.create(game: game)
    assert card.game_id == game.id
  end
end
