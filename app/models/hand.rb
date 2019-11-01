class Hand
  DISPLAY_ORDER = ['trump', 'heart', 'spade', 'diamond', 'club']

  attr_reader :cards

  delegate :empty?, :find, :length, :each, :select, :filter, :sort_by, to: :cards

  def initialize(cards, game)
    @cards = cards
    @game = game
    @led_suit = game.current_trick&.led_suit
  end

  def find_card(slug)
    find_by(slug: slug)
  end

  def pagat
    find_card('trump_1')
  end

  def uhu
    find_card('trump_2')
  end

  def kakadu
    find_card('trump_3')
  end

  def called_king
    find_card(@game.king)
  end

  def cards_in_led_suit?
    find_by(suit: @led_suit).present?
  end

  def trumps?
    find_by(suit: 'trump').present?
  end

  def trumps
    where(suit: 'trump')
  end

  def trump_legal?
    @led_suit == 'trump' || led_suit_cards.empty?
  end

  def called_king_legal?
    @led_suit == called_king.suit? || (led_suit_cards.empty? && trumps.empty?)
  end

  def called_king_only_legal?
    @led_suit == called_king.suit? && led_suit_cards.length == 1
  end

  private

  def led_suit_cards
    where(suit: @led_suit)
  end
end
