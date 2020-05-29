class Bids::AnnouncementsPresenter < Bids::BidsBasePresenter
  def stage
    Stage::ANNOUNCEMENT
  end

  def finished_message
    "announcments are done, ready to play?"
  end

  def biddable_props
    @game.valid_announcements.map do |slug|
      {
        slug: slug,
        name: Bids::AnnouncementPresenter.new(slug).name
      }
    end
  end

  def players_props
    PlayersPresenter.new(@game, @active_player).props_for_announcements
  end

  def hand_props
    HandPresenter.new(@game, @active_player).props_for_bids
  end

  private

  def instruction
    return 'announcements finished, click to continue' if finished?

    return 'make an announcement or pass' if @game.next_player&.id == @active_player.id

    "waiting for #{@game.next_player&.name} to make announcements"
  end

  def finished?
    @game.announcements_finished?
  end
end
