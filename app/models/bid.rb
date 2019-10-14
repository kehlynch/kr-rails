class Bid < ApplicationRecord

  BIDS = [
    ['rufer', 'Rufer'],
    ['solo', 'Solo'],
    ['dreier', 'Dreier']
  ]
  PASS = ['pass', 'Pass']

  def self.available_bids(game, player)
    highest_bid = game.bids.max_by(&:rank) || 0

    return [PASS] + BIDS[highest_bid..] if player.forehand?
    return [PASS] + BIDS[highest_bid + 1..]
  end

  def self.finished_for(game)
    game.bids.where(slug: 'pass').length == 3
  end

  def self.can_bid?(game, player)
    player.bids.find_by(slug: 'pass').nil?
  end

  def rank
    BIDS.find_index { |b| b[0] == slug }
  end

  belongs_to :game
  belongs_to :player
end
