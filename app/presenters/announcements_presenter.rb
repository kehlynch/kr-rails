class AnnouncementsPresenter
  def initialize(game, active_player, visible_stage)
    @game = game
    @active_player = active_player
    @visible_stage = visible_stage
  end
  
  def props_for_bidding
    {
      visible: @visible_stage == Stage::ANNOUNCEMENT,
      bid_picker_visible: @game.next_player&.id == @active_player.id && !@game.announcements.finished?,
      valid_bids: valid_announcements_props,
      finished: @game.announcements.finished?,
      finished_message: "announcments are done, ready to play?",
      instruction: instruction
    }
  end

  def instruction
    return 'announcements finished, click to continue' if @game.bids.finished?

    return 'make an announcement or pass' if @game.next_player.id == @active_player.id

    "waiting for #{@game.next_player.name} to make announcements"
  end


  def props_for_points
    Announcements::SLUGS.map do |slug|
      announcement_props_for_points(slug)
    end.flatten
  end

  private
  def valid_announcements_props
    @game.announcements.valid_announcements.map do |slug|
      valid_announcement_props(slug)
    end
  end

  def valid_announcement_props(slug)
    {
      slug: slug,
      name: AnnouncementPresenter.new(slug).name
    }
  end

  def announcement_props_for_points(slug)
    @game.player_teams.map do |team|
      next unless team.made_announcement?(slug) || team.lost_announcement?(slug)

      {
        shorthand: AnnouncementPresenter.new(slug).shorthand,
        kontra: team.announcement(slug)&.kontra || false,
        off: team.lost_announcement?(slug),
        defence: team.defence?,
        declared: team.announced?(slug)
      }
    end.compact
  end
end
