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
    name = winning_bid_slug == Bids::CALL_KING ? 'Rufer' : BidPresenter.new(winning_bid_slug).name

    kontra_level = @bids.highest&.kontra
    return "#{name} ( x#{kontra_level} )" if kontra_level

    return name
  end

  def winning_bid_slug
    @bids.highest&.slug
  end
end
