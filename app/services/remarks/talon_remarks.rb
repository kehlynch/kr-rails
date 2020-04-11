module Remarks::TalonRemarks
  def self.remarks_for(game)
    return {} unless game.stage == 'pick_talon'

    player_positions = game.players.reject(&:forehand?).reject(&:human?).map(&:position)
    remarks = [
      TurnedOver.new(game).remark,
      GoodAsTrumps.new(game).remark,
      NiceLead.new(game).remark,
      Unlucky.new(game).remark,
      Lucky.new(game).remark,
      HandyBird.new(game).remark
    ]
    max_remark_count = [2, player_positions.count].max
    
    return remarks.compact.sample(max_remark_count).map do |remark|
      [player_positions.delete(player_positions.sample), remark]
    end.to_h
  end
end
