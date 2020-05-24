class Bids::AnnouncementPresenter
  ANNOUNCEMENT_NAMES = {
    Announcement::PASS => 'pass',
    Announcement::PAGAT => 'pagat',
    Announcement::UHU => 'uhu',
    Announcement::KAKADU => 'kakadu',
    Announcement::KING => 'king ultimo',
    Announcement::FORTY_FIVE => '45',
    Announcement::VALAT => 'valat'
  }

  ANNOUNCEMENT_SHORTNAMES = {
    # Announcement::PASS => nil,
    Announcement::PAGAT => 'I',
    Announcement::UHU => 'II',
    Announcement::KAKADU => 'III',
    Announcement::KING => 'K',
    Announcement::FORTY_FIVE => '45',
    Announcement::VALAT => 'V'
  }

  def initialize(slug)
    @slug = slug
  end

  def name
    return kontra_name if @slug.include?('kontra')

    ANNOUNCEMENT_NAMES[@slug] if @slug
  end

  def kontra_name
    name, kontrable_slug, _id = @slug.split('-')
    kontrable_name = ANNOUNCEMENT_NAMES[kontrable_slug] || 'game'
    "#{name} #{kontrable_name}"
  end

  def shorthand
    ANNOUNCEMENT_SHORTNAMES[@slug] if @slug
  end
end
