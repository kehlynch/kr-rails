class BidsBase
  PASS = 'pass'

  attr_reader :bids

  delegate(
    :any?,
    :each,
    :empty?,
    :find,
    :find_by,
    :last,
    :map,
    :select,
    to: :bids
  )

  def initialize(bids, game)
    @game = game
    @bids = bids.sort_by(&:id)
    @players = game.players
  end

end
