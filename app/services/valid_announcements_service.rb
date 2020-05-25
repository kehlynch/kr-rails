class ValidAnnouncementsService
  def initialize(game)
    @game = game
    @announcements = game.announcements
  end

  def valid?(slug)
    valid_announcements.include?(slug)
  end

  def valid_announcements
    return [] unless next_player # game has finished

    valid = Announcement::SLUGS.clone.clone

    if next_player.team == GamePlayer::DEFENDERS || !king
      valid.delete(Announcement::KING)
    end

    valid = valid_kontras + valid

    valid.reject! { |a| announced_by_team?(a) }

    valid += [Announcement::PASS] unless must_announce_bird?

    valid
  end


  private

  attr_reader :game, :announcements

  delegate(
    :king,
    :next_player,
    :bids,
    to: :game
  )

  delegate(
    to: :announcements
  )

  def announced_by_team?(slug)
    next_player.team_members.any? do |game_player|
      game_player.announced?(slug)
    end
  end

  def valid_kontras
    declarer_announcements = game.declarers.map(&:announcements).flatten
    defence_announcements = game.defenders.map(&:announcements).flatten

    bid_kontra = bids.highest&.kontra
    bid_kontra_slug = bids.highest&.kontra_slug

    if next_player.team == GamePlayer::DEFENDERS
      slugs = declarer_announcements.map(&:kontra_slug) + defence_announcements.map(&:rekontra_slug)
      [nil, 4].include?(bid_kontra) ? slugs + [bid_kontra_slug] : slugs
    else
      slugs = defence_announcements.map(&:kontra_slug) + declarer_announcements.map(&:rekontra_slug)
      bid_kontra == 2 ? slugs + [bid_kontra_slug] : slugs
    end.compact
  end

  def must_announce_bird?
    game.bird_required? && next_player.declarer? && !next_player.announced_bird?
  end
end
