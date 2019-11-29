class BidPresenter
  BID_NAMES = {
    Bids::PASS => 'Pass',
    Bids::RUFER => 'Rufer',
    Bids::SOLO => 'Solo',
    Bids::PICCOLO => 'Piccolo',
    Bids::BESSER_RUFER => 'Besser Rufer',
    Bids::DREIER => 'Dreier',
    Bids::BETTEL => 'Bettel',
    Bids::SOLO_DREIER => 'Solo Dreier',
    Bids::CALL_KING => 'Call a king',
    Bids::TRISCHAKEN => 'Trischaken',
    Bids::SECHSERDREIER => 'Sechserdreier'
  }

  BID_SHORTNAMES = {
    Bids::BESSER_RUFER => 'BR',
    Bids::SOLO => 'S',
    Bids::PICCOLO => 'P',
    Bids::DREIER => 'D',
    Bids::BETTEL => 'B',
    Bids::SOLO_DREIER => 'SD',
    Bids::CALL_KING => 'R',
    Bids::TRISCHAKEN => 'T',
    Bids::SECHSERDREIER => 'XI'
  }

  def initialize(slug)
    @slug = slug
  end

  def name(declared = false)
    return BID_NAMES[Bids::RUFER] if declared && @slug == Bids::CALL_KING

    BID_NAMES[@slug] if @slug
  end

  def shorthand
    BID_SHORTNAMES[@slug] if @slug
  end
end
