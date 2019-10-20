class TricksPresenter

  attr_reader :tricks

  delegate :current_trick_finished?, to: :tricks

  def initialize(game_id)
    @tricks = Tricks.new(game_id)
    @players = Players.new(game_id)
  end

  def trick_cards
    cards = @tricks.current_trick_cards

    @players.map do |p|
      [ p, cards.find { |c| c.player == p } ]
    end
  end
end
