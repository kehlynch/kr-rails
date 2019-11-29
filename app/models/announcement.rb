class Announcement < ApplicationRecord
  include Kontrable

  belongs_to :game

  def player
    game.players.find { |p| p.id == player_id }
  end

  def points
    Announcements::POINTS[slug]
  end

  def is_kontra?
    slug.include?('kontra')
  end
end
