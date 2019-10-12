require 'test_helper'

class XCardTest < ActiveSupport::TestCase
  test 'creates a new card' do
    card = XCard.new
    p card
  end
end
