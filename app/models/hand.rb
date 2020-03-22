class Hand
  DISPLAY_ORDER = ['trump', 'heart', 'spade', 'diamond', 'club']

  attr_reader :cards

  delegate(
    :any?,
    :each,
    :empty?,
    :filter,
    :find,
    :length,
    :map,
    :select,
    :sort_by,
    to: :cards
  )

  def initialize(cards, game)
    @cards = cards
    @game = game
    @led_suit = game.current_trick&.led_suit
  end

  def find_card(slug)
    find { |c| c.slug == slug }
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
    find { |c| c.suit == @led_suit }.present?
  end

  def trumps?
    find { |c| c.suit == 'trump' }.present?
  end

  def trumps
    select { |c| c.suit == 'trump' }
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
    select { |c| c.suit == @led_suit }
  end
end
