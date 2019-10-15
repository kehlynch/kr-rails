class Bid < ApplicationRecord

  belongs_to :player
  belongs_to :game

  validates :slug, inclusion: { in: Bidding::RANKED_SLUGS }

  def rank
    Bidding::RANKED_SLUGS.index(slug) || 0
  end

  def talon?
    Bidding::PICK_TALON_SLUGS.include?(slug)
  end

  def king?
    Bidding::PICK_KING_SLUGS.include?(slug)
  end
end
