module Remarks::TalonRemarks
  class NiceLead < TalonRemarkBase
    def remark
      if nice_lead?
        return "there's a nice #{led_suit} to lead to your partner" if led_suit_count == 1

        "there's some nice #{led_suit}s to lead to your partner"
      end
    end

    private

    def nice_lead?
      return false unless @game.king

      p led_suit

      return true if led_suit_count >= 1
    end

    # TODO stick this logic somewhere better
    def led_suit
      @game.king.split("_")[0]
    end

    def led_suit_count
      @talon.flatten.select { |c| c.suit == led_suit }.count
    end
  end
end
