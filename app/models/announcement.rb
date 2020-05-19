class Announcement < ApplicationRecord
  include Kontrable

  belongs_to :game
  belongs_to :game_player

  def points
    Announcements::POINTS[slug]
  end

  def is_kontra?
    slug.include?('kontra')
  end
end
