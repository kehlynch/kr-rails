module Stage
  BID = :bids
  KING = :kings
  PICK_TALON = :pick_talon
  RESOLVE_TALON = :resolve_talon
  ANNOUNCEMENT = :announcements
  TRICK = :tricks
  FINISHED = :finished


  def self.visible_stage_for(game, active_player)
    stage = game.stage

    return stage if stage == Stage::FINISHED

    # show the announcement results if we haven't played a card yet
    return stage if active_player.played_in_any_trick? && stage == Stage::TRICK

    # show the bid results unless we've already made an announcement
    return Stage::BID unless active_player.announcements.any?

    return stage
  end

  def self.next_stage_from(game, stage)
    stages = game.stages
    next_stage_index = stages.index(stage) + 1
    stages[next_stage_index]
  end

  def self.finished?(game, stage)
    case stage
    when BID
      game.won_bid.present?
    when KING
      game.king.present?
    when PICK_TALON
      game.talon_picked.present?
    when RESOLVE_TALON
      game.talon_resolved.present?
    when ANNOUNCEMENT
      game.announcements_finished?
    when TRICK
      game.tricks_finished?
    end
  end
end
