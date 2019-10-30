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

  # CONTRA = 'contra'
  # RECONTRA = 'recontra'
  # SUBCONTRA = 'subcontra'

  POINTS = {
    PAGAT => [2, 1],
    UHU => [3, 1],
    KAKADU => [4, 1],
    KING => [2, 1],
    FORTY_FIVE => [2, 0],
    VALAT => [4, 8]
  }

  attr_reader :announcements

  delegate :each, :map, :select, :find, to: :announcements

  def initialize(announcements, game)
    @game = game
    @announcements = announcements.order(:id).to_a
    @players = @game.players
  end

  def make_announcements!(announcement_slugs)
    add_announcements!(announcement_slugs) if !announcement_slugs.nil?
    until !next_player || next_player.human? || finished?
      announcement_slugs = next_player.pick_announcements(valid_announcements)
      add_announcements!(announcement_slugs)
    end
  end

  def valid_announcements
    player = next_player

    valid = SLUGS

    if player.defence? || !@game.king
      valid.delete(KING)
    end

    valid + [PASS]
  end

  def finished?
    return false unless @announcements.map(&:player_id).uniq.count == 4

    @announcements.last(3).map(&:slug) == [PASS, PASS, PASS]
  end

  def started?
    return @announcements.empty?
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
    player_id = next_player.id
    slugs.each do |slug|
      @announcements << Announcement.create(slug: slug, game_id: @game.id, player_id: player_id)
    end
  end
end
