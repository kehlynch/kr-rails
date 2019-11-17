class TricksPresenter

  attr_reader :tricks

  delegate :current_trick_finished?, :each_with_index, :[], to: :tricks

  def initialize(game)
    @tricks = game.tricks
      .sort_by { |t| -t.trick_index }
      .map { |t| TrickPresenter.new(t) }
  end
end
