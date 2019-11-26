module MatchHelper
  def bid_shorthand(game)
    winning_bid = game.bids.highest
    BidPresenter.new(winning_bid.slug).shorthand
  end

  def points_classes(data)
    data
      .slice(:forehand, :winner, :declarer)
      .select { |k, v| v }
      .compact
      .keys
      .map(&:to_s)
      .join(' ')
  end

  def announcement_classes(data)
    data
      .slice(:off, :defence, :declared)
      .select { |k, v| v }
      .compact
      .keys
      .map(&:to_s)
      .join(' ')
  end
end
