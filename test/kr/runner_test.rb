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
    runner.play(play_card: card.slug)

    assert_equal 1, runner.tricks.length
    assert_equal 4, runner.tricks[0].cards.length
  end

  test 'should play 12 tricks' do
    # set nohuman
    runner = Runner.start(true)
    12.times do
      runner.play(next_trick: true)
    end

    assert_equal 12, runner.tricks.length
    assert_equal 4, runner.tricks[0].cards.length
    talon_points = Card.calculate_points(runner.talon.cards.flatten)
    expected = (69..71)
    assert expected.include?(talon_points + runner.players.map(&:points).sum)
  end

  test 'should play after resume' do
    state = Runner.start.serialize
    runner = Runner.resume(state)
    card = runner.players[0].hand.cards[0]
    runner.play(play_card: card.slug)
  end
end
