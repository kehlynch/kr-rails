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

  delegate :each, :map, :select, :find, :any?, to: :announcements

  def initialize(announcements, game)
    @game = game
    @announcements = announcements.sort_by(&:id)
    @players = @game.players
  end

  def make_announcements!(slugs = [])
    return nil if finished? || (next_player.human? && !slugs.present?)
    
    slugs = next_player.pick_announcements(valid_announcements) if slugs.blank?
    add_announcements!(slugs)
  end

  def valid_announcements
    player = next_player

    return [] unless player # announcing not started
    
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
      Announcement.create(slug: slug, game_id: @game.id, player_id: player.id)
    end
    @announcements += announcements
    return announcements
  end
end
