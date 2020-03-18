class AnnouncementPresenter
  ANNOUNCEMENT_NAMES = {
    Announcements::PASS => 'pass',
    Announcements::PAGAT => 'pagat',
    Announcements::UHU => 'uhu',
    Announcements::KAKADU => 'kakadu',
    Announcements::KING => 'king ultimo',
    Announcements::FORTY_FIVE => '45',
    Announcements::VALAT => 'valat'
  }

  ANNOUNCEMENT_SHORTNAMES = {
    Announcements::PASS => '-',
    Announcements::PAGAT => 'I',
    Announcements::UHU => 'II',
    Announcements::KAKADU => 'III',
    Announcements::KING => 'K',
    Announcements::FORTY_FIVE => '45',
    Announcements::VALAT => 'V'
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
    "#{name} the #{kontrable_name}"
  end

  def shorthand
    ANNOUNCEMENT_SHORTNAMES[@slug] if @slug
  end
end
