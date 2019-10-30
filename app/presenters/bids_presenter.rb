class BidsPresenter
  attr_reader :bids

  delegate :finished?, to: :bids

  def initialize(game)
    @game = game
    @bids = game.bids
    @bid_presenters = @bids.map { |b| BidPresenter.new(b.slug) }
    @players = game.players
  end

  def valid_bids
    @bids.valid_bids.map do |slug|
      [slug, BidPresenter.new(slug).name]
    end
  end

  def declarer
    PlayerPresenter.new(@bids.declarer, @game)
  end

  def winning_bid_name
    return 'Rufer' if winning_bid_slug == Bids::CALL_KING
      
    BidPresenter.new(winning_bid_slug).name
  end

  def winning_bid_slug
    @bids.highest&.slug
  end
end
