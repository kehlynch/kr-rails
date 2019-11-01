class GamePresenter
  def initialize(game)
    @game = game
  end

  def forehand
    PlayerPresenter.new(@game.forehand, @game)
  end
end
