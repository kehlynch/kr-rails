module Remarks
  def self.remarks_for(game)
    return TalonRemarks.remarks_for(game) if game.stage == 'pick_talon'

    return {}
  end
end
