class BidsPresenter
  attr_reader :bids

  delegate :finished?, to: :bids

  def initialize(game_id)
    @game_id = game_id
    @game = Game.find(game_id)
    @bids = Bids.new(game_id)
    @bid_presenters = @bids.map { |b| BidPresenter.new(b.slug) }
    @players = Players.new(game_id)
  end

  def available_bids
    @bids.available_bids(@players.human_player).map do |slug|
      [slug, BidPresenter.new(slug).name]
    end
  end

  def declarer
    PlayerPresenter.new(@bids.declarer, @game_id)
  end

  def human_declarer?
    @game.human_declarer?
  end

  def winning_bid_name
    BidPresenter.new(winning_bid_slug).name
  end

  def winning_bid_slug
    @bids.highest&.slug
  end
end
