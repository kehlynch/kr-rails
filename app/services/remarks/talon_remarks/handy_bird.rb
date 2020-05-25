module Remarks::TalonRemarks
  class HandyBird < TalonRemarkBase
    def remark
      "that bird will be handy" if handy_bird?
    end

    private

    def handy_bird?
      return true if @game.bird_required? && bird?

      false
    end

    def bird?
      trumps.select(&:bird?).any?
    end
  end
end
