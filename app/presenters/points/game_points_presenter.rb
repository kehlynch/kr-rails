class Points::GamePointsPresenter
  def initialize(game)
    @game = game
  end

  def props
    {
      bid: bid_props(game),
      announcements: AnnouncementPresenter.new(game).props_for_points,
      players: players_props(game)
    }
  end

  def players_props
    points = @game
      .match
      .games
      .select { |g| g.id <= @game.id }
      .map { |game| raw_points(game) }
      .reduce([0, 0, 0, 0]) do |raw_points, acc|
        acc.each_with_index.map { |p, i| p + raw_points[i] }
      end

    @game.players.each_with_index.map do |player, i|
      Points::PlayerPointsPresenter.new(player, @game, points[i]).props
    end
  end

  def bid_props
    winning_bid = @game.bids.highest
    {
      kontra: winning_bid.kontra,
      off: !@game.winners.include?(@game.declarer),
      shorthand: BidPresenter.new(winning_bid.slug).shorthand,
      vs_three:  @game.player_teams.defence.length == 3 && @game.bids&.highest&.king?
    }
  end

  def raw_points(game)
    game.players.map(&:game_points)
  end
end
