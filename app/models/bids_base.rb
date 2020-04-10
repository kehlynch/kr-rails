class BidsBase
  PASS = 'pass'

  attr_reader :bids

  delegate(
    :any?,
    :each,
    :empty?,
    :filter,
    :find,
    :find_by,
    :last,
    :map,
    :max_by,
    :select,
    to: :bids
  )

  def initialize(bids, game)
    @game = game
    @bids = bids
    @players = game.players
  end

  def make_bid!(bid_slug = nil)
    return nil if finished? || (next_bidder.human? && !bid_slug)

    bid_slug = bid_slug || get_bot_bid
    bid = add_bid!(bid_slug)
    bids.reload
    bid
  end

  def started?
    !empty?
  end

  def get_bot_bid
    fail NotImplementedError
  end

  def finished?
    fail NotImplementedError
  end

  def first_bidder
    fail NotImplementedError
  end

  def next_bidder
    fail NotImplementedError
  end

  def add_bid!(_slug)
    fail NotImplementedError
  end
end
