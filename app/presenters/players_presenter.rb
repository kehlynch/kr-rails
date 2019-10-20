class PlayersPresenter
  attr_reader :players, :player_presenters

  delegate :human_player, to: :players
  delegate :each, to: :player_presenters

  def initialize(game_id)
    @game_id = game_id
    @players = Players.new(game_id)
    @player_presenters = @players.players.map { |p| PlayerPresenter.new(p, game_id) }
  end

  def human_hand
    human_player.cards_for(@game_id)
  end
end
