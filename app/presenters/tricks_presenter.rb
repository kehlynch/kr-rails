class TricksPresenter

  attr_reader :tricks

  delegate :current_trick_finished?, to: :tricks

  def initialize(game)
    @tricks = game.tricks
    @players = game.players
  end

  def trick_cards
    cards = @tricks.current_trick_cards

    @players.map do |p|
      [ p, cards.find { |c| c.player.id == p.id } ]
    end
  end
end
