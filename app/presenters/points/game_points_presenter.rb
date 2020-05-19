class Points::GamePointsPresenter
  def initialize(game)
    @game = game
  end

  def props
    {
      shorthands: Points::GamePointsShorthandsPresenter.new(@game).props,
      players: players_props
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

    @game.game_players.each_with_index.map do |player, i|
      Points::PlayerPointsPresenter.new(player, @game, points[i]).props
    end
  end

  def raw_points(game)
    game.game_players.map(&:game_points)
  end
end
