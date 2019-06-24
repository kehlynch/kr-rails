# frozen_string_literal: true

require 'test_helper'

class TrickTest < ActionDispatch::IntegrationTest
  test 'should get trick' do
    Trick.new
  end

  test 'winnng_card' do
    winning = Card.new(:diamond, 6)
    trick = Trick.new(
      [
        Card.new(:diamond, 3),
        Card.new(:diamond, 4),
        Card.new(:diamond, 5),
        winning
      ]
    )

    assert_equal trick.winning_card, winning
  end
end
