class Bids::BidPresenter
  BID_NAMES = {
    Bid::PASS => 'Pass',
    Bid::RUFER => 'Rufer',
    Bid::SOLO => 'Solo',
    Bid::PICCOLO => 'Piccolo',
    Bid::BESSER_RUFER => 'Besser Rufer',
    Bid::DREIER => 'Dreier',
    Bid::BETTEL => 'Bettel',
    Bid::SOLO_DREIER => 'Solo Dreier',
    Bid::CALL_KING => 'Call King',
    Bid::TRISCHAKEN => 'Trischaken',
    Bid::SECHSERDREIER => 'Sechserdreier'
  }

  BID_SHORTNAMES = {
    Bid::BESSER_RUFER => 'BR',
    Bid::SOLO => 'S',
    Bid::PICCOLO => 'P',
    Bid::DREIER => 'D',
    Bid::BETTEL => 'B',
    Bid::SOLO_DREIER => 'SD',
    Bid::CALL_KING => 'R',
    Bid::TRISCHAKEN => 'T',
    Bid::SECHSERDREIER => 'XI'
  }

  def initialize(slug)
    @slug = slug
  end

  def name(declared: false)
    return BID_NAMES[Bid::RUFER] if declared && @slug == Bid::CALL_KING

    BID_NAMES[@slug] if @slug
  end

  def shorthand
    BID_SHORTNAMES[@slug] if @slug
  end
end
