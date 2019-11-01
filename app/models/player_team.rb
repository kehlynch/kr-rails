class PlayerTeam
  attr_reader :players, :announcement_status
  delegate :map, to: :players

  def initialize(players, game:, talon:, bid:, king:, defence: false)
    @game = game
    @players = players
    @talon = talon
    @bid = bid
    @defence = defence
    @king = king
    # @announcements = Announcement.where(game_id: game.id, player_id: players.map(&:id))
    @last_trick = @game.tricks.last
    @announcements = AnnouncementPointsContext.new(@game).points_for(self)
  end

  def include?(player)
    @players.map(&:id).include?(player&.id)
  end

  def defence?
    @defence
  end

  def announcement_points
    if @defence
      announcement_own_points - @game.player_teams.declarers.announcement_own_points
    else
      announcement_own_points - @game.player_teams.defence.announcement_own_points
    end
  end

  def announcement_own_points
    @announcements.values.sum
  end

  def made_announcement?(slug)
    @announcements[slug] > 0
  end

  def lost_announcement?(slug)
    @announcements[slug] < 0
  end

  def winner?
    return points >= 35 if @defence

    return points >= 36
  end

  def announced?(slug)
    @game.announcements
      .find { |a| a.slug == slug && players.map(&:id).include?(a.player_id) }
      .present?
  end

  def points
    cards = @players.map { |p| p.scorable_cards }.flatten

    cards = cards + @talon if score_talon?

    Points.points_for_cards(cards)
  end

  def tricks
    @players.map { |p| p.won_tricks }.flatten
  end

  def score_talon?
    return !@defence if @bid&.slug == 'solo' && @talon.find { |c| c.slug == @king }

    return @defence
  end

  def game_points
    bid_points = winner? ? @bid.points : -@bid.points

    defence_count = @defence ? @players.length : 4 - @players.length
    total_points = (bid_points + announcement_points) * defence_count
    points_per_player = total_points/@players.length

    return points_per_player
  end
  
  private
end
