class Announcements
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

  attr_reader :announcements

  delegate(
    :any?,
    :each,
    :find,
    :map,
    :select,
    to: :announcements
  )

  def initialize(announcements, game)
    @game = game
    @announcements = announcements.sort_by(&:id)
    @players = @game.players
  end

  def make_announcements!(slugs = [])
    return nil if finished? || (next_player.human? && slugs.blank?)

    slugs = next_player.pick_announcements(valid_announcements) if slugs.blank?
    add_announcements!(slugs)
  end

  def valid_announcements
    player = next_player

    return [] unless player # announcing not started

    valid = SLUGS.clone.clone

    if player.defence? || !@game.king
      valid.delete(KING)
    end

    valid = valid_kontras + valid

    valid + [PASS]
  end

  def valid_kontras
    declarer_announcements = @game.player_teams.declarers.announcements
    defence_announcements = @game.player_teams.declarers.announcements

    bid_kontra = @game.bids.highest.kontra
    bid_kontra_slug = @game.bids.highest.kontra_slug

    if next_player.defence?
      slugs = declarer_announcements.map(&:kontra_slug) + defence_announcements.map(&:rekontra_slug)
      [nil, 4].include?(bid_kontra) ? slugs + [bid_kontra_slug] : slugs
    else
      slugs = defence_announcements.map(&:kontra_slug) + declarer_announcements.map(&:rekontra_slug)
      bid_kontra == 2 ? slugs + [bid_kontra_slug] : slugs
    end.compact
  end

  def finished?
    return false unless @announcements.map(&:player_id).uniq.count == 4

    @announcements.last(3).map(&:slug) == [PASS, PASS, PASS]
  end

  def started?
    return !@announcements.empty?
  end

  def next_player
    if @announcements.empty?
      return @game.declarer
    else
      return @players.next_from(@announcements[-1].player)
    end
  end

  private

  def add_announcements!(slugs)
    player = next_player
    announcements = slugs.map do |slug|
      add_announcement!(slug, player)
    end
    @announcements += announcements
    return announcements
  end

  def add_announcement!(slug, player)
    add_kontra!(slug) if slug.include?('kontra')
    Announcement.create(slug: slug, game_id: @game.id, player_id: player.id)
  end

  def add_kontra!(kontra_slug)
    kontrable = Kontrable.find_kontrable(kontra_slug)
    kontrable.update_kontra(kontra_slug)
  end
end
