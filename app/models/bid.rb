class Bid < ApplicationRecord
  include Kontrable

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

  def announcements?
    ![Bids::PICCOLO, Bids::BETTEL, Bids::TRISCHAKEN].include?(slug)
  end

  def announcements_doubled?
    [Bids::SOLO, Bids::SOLO_DREIER].include?(slug)
  end

  def negative?
    [Bids::PICCOLO, Bids::BETTEL, Bids::TRISCHAKEN].include?(slug)
  end

  def declarer_leads?
    [Bids::BETTEL].include?(slug)
  end

  def contracted_trick_count
    return 1 if slug == Bids::PICCOLO
    return 0 if slug == Bids::BETTEL
    return nil
  end

  def points
    Bids::POINTS[slug]
  end
end
