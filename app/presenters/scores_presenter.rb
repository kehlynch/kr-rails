class ScoresPresenter
  def initialize(game, active_player)
    @game = game
    @active_player = active_player
  end

  def props
    {
      players: players_props
    }
  end

  private

  def players_props
    @game.game_players.map do |player|
      ScorePresenter.new(player, @game, @active_player).props
    end
  end
end
