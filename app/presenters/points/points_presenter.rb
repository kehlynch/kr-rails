class Points::PointsPresenter
  def initialize(match, active_player)
    @match = match
    @active_player = active_player
  end

  def props
    {
      player_names: @match.players.map(&:name),
      games: games,
    }
  end

  private

  def games
    @match.games.select(&:finished?).map do |game|
      Points::GamePointsPresenter.new(game).props
    end
  end
end
