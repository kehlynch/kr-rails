class AnnouncementPointsContext
  def initialize(game)
    @game = game
    @tricks = game.tricks
  end

  def points_for(team)
    @points_for ||= {
      'pagat' => bird_points(1, team),
      'uhu' => bird_points(2, team),
      'kakadu' => bird_points(3, team),
      'king' => king_points(team),
      'forty_five' => forty_five_points(team),
      'valat' => valat_points(team)
    }.map do |k, v|
      multiplier = team.announcement(k)&.kontra_multiplier || 1
      [k, multiplier * v]
    end.to_h
  end

  private

  def bird_points(number, team)
    AnnouncementPoints::Bird.new(number, team: team, tricks: @tricks).points
  end

  def king_points(team)
    AnnouncementPoints::King.new(@game.king, team: team, trick: @tricks.last).points
  end

  def forty_five_points(team)
    if team.announced?(Announcements::FORTY_FIVE)
      return 2 if team.points >= 45

      return -2
    end
    return 0
  end

  def valat_points(team)
    made = team.tricks.length == 12
    if team.announced?(Announcements::VALAT)
      return 8 if made

      return -8
    end
    return 4 if made

    return 0
  end
end
