class PlayersPresenter
  attr_reader :game, :player_presenters

  delegate :human_player, to: :game
  delegate :each, :[], to: :player_presenters

  def initialize(game)
    @game = game
    @player_presenters = @game.players.map { |p| PlayerPresenter.new(p, game) }
  end

  def human_hand
    display_order = ['trump', 'heart', 'spade', 'diamond', 'club']
    human_player.hand.sort_by do |c|
      [display_order.index(c.suit), -c.value]
    end
  end
end
