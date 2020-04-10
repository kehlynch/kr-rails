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
    @bids = bids.sort_by(&:id)
    @players = game.players
  end

  def started?
    !empty?
  end

  def first_bidder
    fail NotImplementedError
  end

  def next_bidder
    if empty?
      return first_bidder
    else
      return @players.next_from(last.player)
    end
  end
end
