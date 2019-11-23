class MatchPresenter
  attr_reader :games

  def initialize(match, active_player_id)
    @match = match
    @games = match.games.map { |g| GamePresenter.new(g, active_player_id) }
  end
end
