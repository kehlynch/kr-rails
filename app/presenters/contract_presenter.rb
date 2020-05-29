class ContractPresenter
  def initialize(game)
    @game = game
  end

  def props
    {
      won_bid: won_bid,
      called_king: @game.king
    }
  end

  private

  def won_bid
    return nil unless Stage.finished?(@game, Stage::BID)
    Bids::BidPresenter.new(@game.winning_bid&.slug).name(declared: true)
  end
end
