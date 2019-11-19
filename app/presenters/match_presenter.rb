class MatchPresenter
  attr_reader :games

  def initialize(match)
    @match = match
    @games = match.games.map { |g| GamePresenter.new(g) }
  end
end
