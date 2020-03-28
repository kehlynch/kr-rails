class TricksPresenter
  attr_reader :tricks

  delegate(
    :[],
    :current_trick_finished?,
    :each_with_index,
    :length,
    to: :tricks
  )

  def initialize(game)
    tricks = game.tricks.sort_by(&:trick_index)

    @tricks = (0..11).map do |trick_index|
      TrickPresenter.new(tricks[trick_index], trick_index)
    end
  end
end
