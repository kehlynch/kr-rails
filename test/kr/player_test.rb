# frozen_string_literal: true

require 'test_helper'

class PlayerTest < ActionDispatch::IntegrationTest
  test 'should get player' do
    create_player
  end

  test 'remove_from_hand' do
    player = create_player
    card = player.hand.cards[0]
    assert_equal card, player.remove_from_hand(card.slug)
    assert_equal 11, player.hand.cards.length
  end

  test 'pick_card' do
    player = create_player
    card = player.pick_card([])
    assert card.is_a?(Card)
  end

  test 'pick_card with trick' do
    player = create_player
    trick = Trick.new([Card.new(:diamond, 1, create_player)])
    card = player.pick_card([trick])
    assert card.is_a?(Card)
  end

  def create_player
    hand = Deck.new.hands[0]
    Player.new(0, hand)
  end
end
