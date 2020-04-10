class Announcements < BidsBase
  PASS = 'pass'
  PAGAT = 'pagat'
  UHU = 'uhu'
  KAKADU = 'kakadu'
  KING = 'king'
  FORTY_FIVE = 'forty_five'
  VALAT = 'valat'

  SLUGS = [
    PAGAT,
    UHU,
    KAKADU,
    KING,
    FORTY_FIVE,
    VALAT
  ]

  POINTS = {
    PAGAT => [2, 1],
    UHU => [3, 1],
    KAKADU => [4, 1],
    KING => [2, 1],
    FORTY_FIVE => [2, 0],
    VALAT => [4, 8]
  }

  def valid_announcements
    player = next_bidder

    return [] unless player # announcing not started

    valid = SLUGS.clone.clone

    if player.defence? || !@game.king
      valid.delete(KING)
    end

    valid = valid_kontras + valid

    valid.reject! { |s| player.team.announced?(s) }

    valid + [PASS]
  end

  def valid_kontras
    declarer_announcements = @game.player_teams.declarers.announcements
    defence_announcements = @game.player_teams.declarers.announcements

    bid_kontra = @game.bids.highest.kontra
    bid_kontra_slug = @game.bids.highest.kontra_slug

    if next_bidder.defence?
      slugs = declarer_announcements.map(&:kontra_slug) + defence_announcements.map(&:rekontra_slug)
      [nil, 4].include?(bid_kontra) ? slugs + [bid_kontra_slug] : slugs
    else
      slugs = defence_announcements.map(&:kontra_slug) + declarer_announcements.map(&:rekontra_slug)
      bid_kontra == 2 ? slugs + [bid_kontra_slug] : slugs
    end.compact
  end

  def finished?
    return false unless map(&:player_id).uniq.count == 4

    last(3).map(&:slug) == [PASS, PASS, PASS]
  end

  def first_bidder
    return @game.declarer
  end

  def next_bidder
    return first_bidder if empty?

    return last.player if last.slug != PASS

    @players.next_from(last.player)
  end

  def get_bot_bid
    next_bidder.pick_announcement(valid_announcements)
  end

  def add_bid!(slug)
    add_kontra!(slug) if slug.include?('kontra')
    Announcement.create(slug: slug, game_id: @game.id, player_id: next_bidder.id)
  end

  private

  def add_kontra!(kontra_slug)
    kontrable = Kontrable.find_kontrable(kontra_slug)
    kontrable.update_kontra(kontra_slug)
  end
end
