class Announcement < ApplicationRecord

  belongs_to :game

  validates :slug, inclusion: { in: Announcements::SLUGS + [Announcements::PASS] }

  def player
    game.players.find { |p| p.id == player_id }
  end

  def points
    Announcements::POINTS[slug]
  end
end
