class AnnouncementPicker
  def initialize(hand:, bird_required:)
    @hand = hand
    @bird_required = bird_required
  end

  def pick
    return pick_bird if @bird_required

    return Announcements::PASS
  end

  def pick_bird
    return Announcements::PAGAT if @hand.pagat
    return Announcements::UHU if @hand.uhu
    return Announcements::KAKADU if @hand.kakadu
    return Announcements::PAGAT
  end
end
