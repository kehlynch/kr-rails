class PlayersPresenter
  attr_reader :game, :player_presenters

  delegate :human_player, to: :game
  delegate(
    :[],
    :each,
    :each_with_index,
    :find,
    :first,
    :map,
    :reject,
    to: :player_presenters
  )

  def initialize(game, player_id)
    @game = game
    presenters = @game.players.map { |p| PlayerPresenter.new(p, game) }
    player_index = presenters.index { |p| p.id == player_id }
    @player_presenters = presenters[player_index..] + presenters[0...player_index]
  end
end
