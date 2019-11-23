class TrickPresenter
  attr_reader :trick
  delegate(
    :finished?,
    :trick_index,
    :winning_card,
    :won_card,
    to: :trick
  )
  def initialize(trick)
    @trick = trick
  end

  def cards
    cards = @trick&.cards || []

    [0, 1, 2, 3].map do |player_position|
      cards.find { |c| c.player.position == player_position }
    end
  end
end
