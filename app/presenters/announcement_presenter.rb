class AnnouncementPresenter
  ANNOUNCEMENT_NAMES = {
    Announcements::PASS => 'Pass',
    Announcements::PAGAT => 'Pagat',
    Announcements::UHU => 'Uhu',
    Announcements::KAKADU => 'Kakadu',
    Announcements::KING => 'King Ultimo',
    Announcements::FORTY_FIVE => '45',
    Announcements::VALAT => 'Valat'
  }

  ANNOUNCEMENT_SHORTNAMES = {
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
    ANNOUNCEMENT_NAMES[@slug] if @slug
  end

  def shorthand
    ANNOUNCEMENT_SHORTNAMES[@slug] if @slug
  end
end
