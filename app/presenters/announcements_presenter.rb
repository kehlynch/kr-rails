class AnnouncementsPresenter
  def initialize(game)
    @game = game
  end
  
  def props_for_bidding
    @game.announcements.valid_announcements.map do |slug|
      {
        slug: slug,
        name: AnnouncementPresenter.new(slug).name
      }
    end
  end

  def props_for_points
    Announcements::SLUGS.map do |slug|
      announcement_props_for_points(slug)
    end.flatten
  end

  private

  def announcement_props_for_points(slug)
    @game.player_teams.map do |team|
      next unless team.made_announcement?(slug) || team.lost_announcement?(slug)

      {
        shorthand: AnnouncementPresenter.new(slug).shorthand,
        kontra: team.announcement(slug)&.kontra || false,
        off: team.lost_announcement?(slug),
        defence: team.defence?,
        declared: team.announced?(slug)
      }
    end.compact
  end
end
