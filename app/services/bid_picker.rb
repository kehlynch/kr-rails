class BidPicker

  def initialize(bids:, hand:)
    @bids = bids
    @hand = hand
  end

  def pick
    return Bids::BESSER_RUFER if @bids.include?(Bids::BESSER_RUFER) && besser_rufer

    return Bids::DREIER if perc(80) && @bids.include?(Bids::DREIER) && trump_count >= 8

    return Bids::SOLO if perc(80) && @bids.include?(Bids::SOLO) && trump_count >= 6

    return Bids::RUFER if perc(80) && @bids.include?(Bids::RUFER)

    return Bids::PASS if perc(40) && @bids.include?(Bids::PASS)

    return @bids.sample
  end

  private

  def besser_rufer
    return true if @hand.pagat.present? && @hand.trumps.length > 6 && perc(80)
    return true if @hand.uhu.present? && @hand.trumps.length > 6 && perc(60)
    return true if @hand.kakadu.present? && @hand.trumps.length > 7 && perc(60)
  end

  def perc(percentage)
    rand > percentage/100
  end

  def trump_count
    @hand.filter { |c| c.suit == 'trump' }.length
  end
end
