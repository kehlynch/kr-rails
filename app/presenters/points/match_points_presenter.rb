class Points::MatchPointsPresenter
  def initialize(match, active_player, visible_stage)
    @match = match
    @active_player = active_player
    @visible_stage = visible_stage
  end

  def props
    {
      visible: @visible_stage == Stage::FINISHED,
      player_names: @match.players.map(&:name),
      games: games,
    }
  end

  private

  def games
    @match.games.select(&:finished?).map do |game|
      GamePointsPresenter.new(game).props
    end
  end
end
