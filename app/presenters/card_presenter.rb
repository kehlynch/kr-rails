module CardPresenter
  FACE_NAMES = {
    8 => 'King',
    7 => 'Queen',
    6 => 'Knight',
    5 => 'Jack'
  }

  def initialize(slug)
    @slug = slug
    @value, @suit = @slug.split('_')
    @value = @value.to_i
  end

  def name
    return trump_name(@value) if @suit == 'trump'

    return face_name(@value, @suit) if [5, 6, 7, 8].include?(@value)

    return red_pip_name(@value, @suit) if ['diamond', 'heart'].include?(@suit)

    return black_pip_name(@value, @suit)
  end

  private

  # not being used at the moment - will want a better implementation if it is
  def trump_name
    "#{@value} of trumps"
  end

  def face_name
    "#{FACE_NAMES[@value]} of #{@suit.capitalize}"
  end

  def red_pip_name
    name = @value == 4 ? 'Ace' : 5 - @value
    "#{name} of #{@suit.capitalize}"
  end

  def black_pip_name
    "#{@value + 6} of #{@suit.capitalize}"
  end
end
