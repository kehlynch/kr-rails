class PlayerTeam
  attr_reader :players, :announcement_status
  delegate :map, :length, to: :players

  def initialize(players, game:, talon:, bid:, king:, defence: false)
    @game = game
    @players = players
    @talon = talon
    @bid = bid
    @defence = defence
    @king = king
  end

  def announcement_points_lookup
    @announcement_points_lookup ||= @bid.announcements? ? AnnouncementPointsContext.new(@game).points_for(self) : {}
  end

  def include?(player)
    @players.map(&:id).include?(player&.id)
  end

  def defence?
    @defence
  end

  def announcement_points
    points =
      if @defence
        announcement_own_points - @game.player_teams.declarers.announcement_own_points
      else
        announcement_own_points - @game.player_teams.defence.announcement_own_points
      end

    @bid.announcements_doubled? ? 2 * points : points
  end

  def announcement_own_points
    announcement_points_lookup.values.sum
  end

  def made_announcement?(slug)
    (announcement_points_lookup[slug] || 0) > 0
  end

  def lost_announcement?(slug)
    (announcement_points_lookup[slug] || 0) < 0
  end

  def winner?
    return contracted_trick_count_won?(@bid.contracted_trick_count) if @bid&.contracted_trick_count

    return points >= 35 if @defence

    return points >= 36
  end

  def announcements
    @game.announcements
      .select { |a| players.map(&:id).include?(a.player_id) }
  end

  def announced?(slug)
    announcements
      .find { |a| a.slug == slug }
      .present?
  end

  def announcement(slug)
    announcements.find { |a| a.slug == slug }
  end

  def points
    cards = @players.map { |p| p.scorable_cards }.flatten

    cards += @talon if score_talon?

    Points.points_for_cards(cards)
  end

  def tricks
    @players.map { |p| p.won_tricks }.flatten
  end

  def score_talon?
    return !@defence if @bid&.slug == Bids::SOLO && @talon.find { |c| c.slug == @king }

    return @defence
  end

  def game_points
    return 0 unless @game.finished?

    bid_points = (winner? ? @bid.points : -@bid.points) * @bid.kontra_multiplier

    defence_count = @defence ? @players.length : 4 - @players.length
    total_points = (bid_points + announcement_points) * defence_count
    points_per_player = total_points / @players.length

    return points_per_player
  end

  private

  def contracted_trick_count_won?(trick_count)
    if @defence
      tricks.length != (12 - trick_count)
    else
      tricks.length == trick_count
    end
  end
end
