# frozen_string_literal: true

require 'test_helper'

class RunnerTest < ActionDispatch::IntegrationTest
  test 'should get runner' do
    Runner.start
  end

  test 'should serialize' do
    runner = Runner.start
    runner.serialize
  end

  test 'should play' do
    runner = Runner.start
    card = runner.players[0].hand.cards[0]
    runner.play(card.slug)

    assert_equal 1, runner.tricks.length
    assert_equal 4, runner.tricks[0].cards.length
  end

  test 'should play after resume' do
    state = Runner.start.serialize
    runner = Runner.resume(state)
    card = runner.players[0].hand.cards[0]
    runner.play(card.slug)
  end

  test 'next_player returns player 0 initially' do
    runner = Runner.start
    assert_equal runner.next_player, runner.players[0]
  end

  test 'next_player returns player 1 after card played' do
    runner = Runner.start
    player = runner.players[0]
    card = player.hand.cards[0]
    runner.play_card(card.slug, player)
    # default forehand is player 0
    assert_equal runner.next_player, runner.players[1]
  end

  test 'play_card removes card from player hand' do
    runner = Runner.start
    # default forehand
    player = runner.players[0]

    card = player.hand.cards[0]
    runner.play_card(card.slug, player)
    assert_equal player.hand.cards.length, 11
  end

  test 'play_card adds card to trick' do
    runner = Runner.start
    player = runner.players[0]
    card = player.hand.cards[0]
    runner.play_card(card.slug, player)
    assert_equal runner.tricks[0].cards[0], card
  end
end
