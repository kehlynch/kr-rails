# frozen_string_literal: true

class Integer
  def to_roman
    conversion = {
      1 => 'I',
      4 => 'IV',
      5 => 'V',
      9 => 'IX',
      10 => 'X',
      40 => 'XL',
      50 => 'L',
      90 => 'XC',
      100 => 'C',
      400 => 'CD',
      500 => 'D',
      900 => 'CM',
      1000 => 'M'
    }

    intervals = conversion.keys.sort.reverse
    roman = ''
    current = self
    until intervals.empty?
      if current - intervals[0] >= 0
        roman += conversion[intervals[0]]
        current -= intervals[0]
      else
        intervals.shift
      end
    end

    roman
  end
end
