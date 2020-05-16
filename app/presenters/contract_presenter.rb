class ContractPresenter
  def initialize(game)
    @game = game
  end

  def props
    {
      won_bid: won_bid,
      called_king: @game.king,
    }
  end

  private

  def won_bid
    return nil unless @game.bids.finished?
    Bids::BidPresenter.new(@game.bids.highest&.slug).name
  end
end
