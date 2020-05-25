class AnnouncementPicker
  def initialize(hand:, bird_required:)
    @hand = hand
    @bird_required = bird_required
  end

  def pick
    return pick_bird if @bird_required

    return Announcement::PASS
  end

  def pick_bird
    return Announcement::PAGAT if @hand.include_slug?('trump_1')
    return Announcement::UHU if @hand.include_slug?('trump_2')
    return Announcement::KAKADU if @hand.include_slug?('trump_3')
    return Announcement::PAGAT
  end
end
