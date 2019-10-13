require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'creates a new game' do
    game = Game.create
    assert_equal game.players.length, 4
    assert_equal game.cards.length, 54

    assert_equal game.talon.length, 2
    assert_equal game.tricks.length, 1
    assert_equal game.stage, :pick_contract

    game.players.each do |player|
      assert player.cards.length == 12
    end
  end

  test 'should play card' do
    game = Game.create
    card = game.players[0].cards[0]
    game.play_current_trick!(card.slug)

    assert_equal 1, game.tricks.length
    assert_equal 4, game.tricks[0].cards.length
  end

  test 'should pick talon' do
    game = Game.create
    game.pick_talon!(0)
    assert_equal 15, game.players[0].cards.length
  end

  test 'should put down discards' do
    game = Game.create
    game.pick_talon!(0)
    card_slugs = game.players[0].cards[0..2].map(&:slug)
    game.resolve_talon!(card_slugs)
    assert_equal 12, game.players[0].cards.length
  end
end
