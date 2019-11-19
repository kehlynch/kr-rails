class GamePresenter
  attr_reader :game
  delegate :finished?, :winners, :declarer, :bids, :player_teams, to: :game

  def initialize(game)
    @game = game
    @players = game.players
  end

  def forehand
    PlayerPresenter.new(@game.forehand, @game)
  end

  def summary
    return nil unless @game.finished?

    {
      bid: bid_shorthand,
      vs_three: vs_three,
      off: !@game.winners.include?(@game.declarer),
      announcements: announcements_summary,
      players: players_summary,
    }
  end

  def players_summary
    points = game
      .match
      .games
      .select { |g| g.id <= @game.id }
      .map { |g| GamePresenter.new(g) }
      .map(&:raw_points)
      .reduce([0, 0, 0, 0]) do |points, acc|
        acc.each_with_index.map { |p, i| p + points[i] }
      end

    @players.each_with_index.map do |player, i|
      {
        points: points[i],
        forehand: player.forehand?,
        winner: @game.winners.map(&:id).include?(player.id),
        declarer: @game.declarer.id == player.id
      }
    end
  end

  def announcements_summary
    Announcements::SLUGS.map do |slug|
      announcement_summary(slug)
    end.flatten
  end

  def announcement_summary(slug)
    @game.player_teams.map do |team|
      if team.made_announcement?(slug) || team.lost_announcement?(slug)
        {
          announcement: AnnouncementPresenter.new(slug).shorthand,
          off: team.lost_announcement?(slug),
          defence: team.defence?,
          declared: team.announced?(slug)
        }
      end
    end.compact
  end


  def vs_three
    ['solo', 'solo_dreier'].include?(@game.bids.highest&.slug) && @game.player_teams.defence.length == 3
  end

  def bid_shorthand
    winning_bid = @game.bids.highest
    BidPresenter.new(winning_bid.slug).shorthand
  end

  def bid_classes
    classes = []
    classes << 'vs-three' if ['solo', 'solo_dreier'].include?(game.bids.highest&.slug) && @game.player_teams.defence.length == 3
    classes << 'off' if !@game.winners.include?(@game.declarer)
    classes.join(' ')
  end

  def raw_points
    return [] if not @game.finished?
    @players.map(&:game_points)
  end

  private
end
