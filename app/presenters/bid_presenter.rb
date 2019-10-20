class BidPresenter
  BID_NAMES = {
    Bids::PASS => 'Pass',
    Bids::RUFER => 'Rufer',
    Bids::SOLO => 'Solo',
    Bids::DREIER => 'Dreier',
    Bids::PASS => 'Pass',
    Bids::CALL_KING => 'Call a king',
    Bids::TRISCHAKEN => 'Trischaken',
    Bids::SECHSERDREIER => 'Sechserdreier'
  }

  def initialize(slug)
    @slug = slug
  end

  def name
    BID_NAMES[@slug] if @slug
  end
end
