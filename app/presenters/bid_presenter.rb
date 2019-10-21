class BidPresenter
  BID_NAMES = {
    Bids::PASS => 'Pass',
    Bids::RUFER => 'Rufer',
    Bids::SOLO => 'Solo',
    Bids::DREIER => 'Dreier',
    Bids::CALL_KING => 'Call a king',
    Bids::TRISCHAKEN => 'Trischaken',
    Bids::SECHSERDREIER => 'Sechserdreier'
  }

  BID_SHORTNAMES = {
    Bids::SOLO => 'S',
    Bids::DREIER => 'D',
    Bids::CALL_KING => 'R',
    Bids::TRISCHAKEN => 'T',
    Bids::SECHSERDREIER => 'XI'
  }

  def initialize(slug)
    @slug = slug
  end

  def name
    BID_NAMES[@slug] if @slug
  end

  def shorthand
    BID_SHORTNAMES[@slug] if @slug
  end
end
