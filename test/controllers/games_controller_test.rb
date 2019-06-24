# frozen_string_literal: true

require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get new_game_url
    assert_response :success
  end

  # test 'should get play' do
  #   get game_play_url
  #   assert_response :success
  # end
end
