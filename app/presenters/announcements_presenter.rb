class AnnouncementsPresenter
  attr_reader :announcements

  delegate :finished?, to: :announcements

  def initialize(game)
    @game = game
    @announcements = game.announcements
  end

  def valid_announcements
    @announcements.valid_announcements.map do |slug|
      [slug, AnnouncementPresenter.new(slug).name]
    end
  end
end
