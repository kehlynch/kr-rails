module Remarks::TalonRemarks
  class Lucky < TalonRemarkBase
    def remark
      "ooh 😲" if lucky?
    end

    private

    def lucky?
      return true if total_points >= 20 && pick_six?

      return true if halves_points.max >= 12

      false
    end
  end
end
