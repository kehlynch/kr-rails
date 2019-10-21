class BidPicker

  def initialize(bids:, hand:)
    @bids = bids
    @hand = hand
  end

  def pick
    # return Bids::DREIER if @bids.include?(Bids::DREIER) && trump_count >= 8

    # return Bids::SOLO if @bids.include?(Bids::SOLO) && trump_count >= 6

    # return Bids::RUFER if @bids.include?(Bids::RUFER)

    return Bids::PASS if @bids.include?(Bids::PASS)

    return @bids.sample
  end

  private

  def trump_count
    @hand.filter { |c| c.suit == 'trump' }.length
  end
end
