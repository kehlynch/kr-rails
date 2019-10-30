class Bid < ApplicationRecord

  belongs_to :game

  validates :slug, inclusion: { in: Bids::RANKED_SLUGS }

  def player
    game.players.find { |p| p.id == player_id }
  end

  def rank
    Bids::RANKED_SLUGS.index(slug) || 0
  end

  def talon?
    Bids::PICK_TALON_SLUGS.include?(slug)
  end

  def king?
    Bids::PICK_KING_SLUGS.include?(slug)
  end

  def trischaken?
    Bids::TRISCHAKEN == slug
  end

  # breaking this out - it might cause issues if I change the way
  # bids are created. There's a bid_index on the model that's not
  # being set or used - could use that here
  def bidding_order
    id
  end

  def points
    Bids::POINTS[slug]
  end
end
