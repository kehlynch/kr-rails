class BidPicker

  def initialize(bids:, hand:)
    @bids = bids
    @hand = hand
  end

  def pick
    return Bid::BESSER_RUFER if @bids.include?(Bid::BESSER_RUFER) && besser_rufer

    return Bid::DREIER if perc(80) && @bids.include?(Bid::DREIER) && trump_count >= 8

    return Bid::SOLO if perc(40) && @bids.include?(Bid::SOLO) && trump_count >= 6

    return Bid::RUFER if perc(80) && @bids.include?(Bid::RUFER)

    return Bid::PASS if perc(40) && @bids.include?(Bid::PASS)

    return @bids.sample
  end

  private

  def besser_rufer
    return true if pagat? && @hand.trumps.length > 6 && perc(80)
    return true if uhu? && @hand.trumps.length > 6 && perc(60)
    return true if kakadu? && @hand.trumps.length > 7 && perc(60)
  end

  def perc(percentage)
    rand > percentage/100
  end

  def trump_count
    @hand.filter { |c| c.suit == 'trump' }.length
  end

  def pagat?
    @hand.find { |c| c.slug == 'trump_1'}.present?
  end

  def uhu?
    @hand.find { |c| c.slug == 'trump_2'}.present?
  end

  def kakadu?
    @hand.find { |c| c.slug == 'trump_3'}.present?
  end
end
