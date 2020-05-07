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

  def self.pick_talon_stage?(stage)
    [PICK_TALON, PICK_WHOLE_TALON].include?(stage)
  end

  def self.resolve_talon_stage?(stage)
    [RESOLVE_TALON, RESOLVE_WHOLE_TALON].include?(stage)
  end

  def self.visible_stage_for(game, active_player)
    stage = game.stage

    return stage if stage == Stage::FINISHED

    # show the announcement results if we haven't played a card yet
    return stage if active_player.played_in_any_trick? && stage == Stage::TRICK

    # show the bid results unless we've already made an announcement
    return Stage::BID unless active_player.announcements.any?

    return stage
  end
end
