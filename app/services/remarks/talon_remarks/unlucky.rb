module Remarks::TalonRemarks
  class Unlucky < TalonRemarkBase
    def remark
      "😬" if unlucky?
    end

    private

    def unlucky?
      return true if total_points <= 6 && trump_count <= 2 && highest_trump_value <= 10

      return true if total_points <= 8 && trump_count <= 1 && highest_trump_value <= 15

      return true if trump_count == 0

      false
    end
  end
end
