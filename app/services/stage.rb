module Stage
  BID = 'make_bid'
  KING = 'pick_king'
  PICK_TALON = 'pick_talon'
  PICK_WHOLE_TALON = 'pick_whole_talon'
  RESOLVE_TALON = 'resolve_talon'
  RESOLVE_WHOLE_TALON = 'resolve_whole_talon'
  ANNOUNCEMENT = 'make_announcement'
  TRICK = 'play_card'
  FINISHED = 'finished'

  TALON_STAGES = [PICK_TALON, PICK_WHOLE_TALON, RESOLVE_TALON, RESOLVE_WHOLE_TALON]

  def self.talon_stage?(stage)
    TALON_STAGES.include?(stage)
  end
end
