module Remarks::TalonRemarks
  def self.remarks_for(game)
    return {} unless game.stage == 'pick_talon'

    player_ids = game.players.reject(&:forehand?).reject(&:human?).map(&:id)
    remarks = [
      TurnedOver.new(game).remark,
      GoodAsTrumps.new(game).remark,
      NiceLead.new(game).remark,
      Unlucky.new(game).remark,
      Lucky.new(game).remark,
      HandyBird.new(game).remark
    ]
    max_remark_count = [2, player_ids.count].max

    random_generator = Random.new(game.id) # we want the same 'random' remarks if the game is reloaded
   
    random_remark_indexes = max_remark_count.times.collect { random_generator.rand(remarks.count) }
    return remarks.values_at(*random_remark_indexes).map do |remark|
      player_index = random_generator.rand(player_ids.count)
      [player_ids.delete(player_ids[player_index]), remark]
    end.to_h
  end
end
