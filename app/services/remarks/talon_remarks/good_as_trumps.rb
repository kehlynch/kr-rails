module Remarks::TalonRemarks
  class GoodAsTrumps < TalonRemarkBase
    GOOD_AS_TRUMPS_COUNT = 3

    def remark
      "those #{max_cards_suit} will be as good as trumps" if good_as_trumps?
    end

    private

    def good_as_trumps?
      return true if max_cards_suit_count >= GOOD_AS_TRUMPS_COUNT

      false
    end

    def max_cards_suit
      @talon
        .flatten
        .reject(&:trump?)
        .map(&:suit)
        .group_by(&:to_s)
        .values.max_by(&:size).first
    end

    def max_cards_suit_count
      @talon.flatten.select { |c| c.suit == max_cards_suit }.count
    end
  end
end
