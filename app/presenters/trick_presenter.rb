class TrickPresenter
  attr_reader :trick, :trick_index

  def initialize(trick, trick_index)
    @trick = trick
    @trick_index = trick_index
  end

  def cards
    cards = @trick&.cards || []

    [0, 1, 2, 3].map do |player_position|
      cards.find { |c| c.player.position == player_position }
    end
  end

  def finished?
    @trick&.finished? || false
  end

  def winning_card
    @trick&.winning_card
  end

  def won_card
    @trick&.won_card
  end
end
