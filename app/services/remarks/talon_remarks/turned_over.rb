module Remarks::TalonRemarks
  class TurnedOver < TalonRemarkBase
    def remark
      "should've turned 'em over" if should_turned_over?
    end

    private

    def should_turned_over?
      return false if turned_over?
      
      return true if trump_count >= 4 && highest_trump_value >= 12

      return true if trump_count >= 2 && total_points >= 12

      false
    end
  end
end
