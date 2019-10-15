# frozen_string_literal: true

require 'test_helper'

class LegacyTrickTest < ActionDispatch::IntegrationTest
  test 'should get trick' do
    LegacyTrick.new
  end

  test 'winnng_card' do
    winning = LegacyCard.new(:diamond, 6)
    trick = LegacyTrick.new(
      [
        LegacyCard.new(:diamond, 3),
        LegacyCard.new(:diamond, 4),
        LegacyCard.new(:diamond, 5),
        winning
      ]
    )

    assert_equal trick.winning_card, winning
  end
end
