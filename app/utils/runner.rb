# A class responsible for sending commands to the game
# and announcing the results
# Pass it an action from the active player and it
# will make all the computer player moves happen and announce the results
class Runner

  class RunnerError < StandardError; end

  def initialize(game)
    @game = game
    @broadcaster = Broadcaster.new(game)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def advance!(**params)
    action = @game.stage

    case action
    when 'make_bid'
      advance_bidding!(params[:make_bid])
    when 'pick_king'
      pick_king!(params[:king_slug])
    when 'pick_talon'
      pick_talon!(params[:pick_talon].to_i)
    when 'pick_whole_talon'
      pick_whole_talon!
    when 'resolve_talon'
      resolve_talon!(params[:resolve_talon])
    when 'resolve_whole_talon'
      resolve_talon!(params[:resolve_whole_talon])
    when 'make_announcement'
      advance_announcements!(params[:make_announcement])
    when 'play_card'
      card_slug = params[:play_card][0] if params[:play_card]
      advance_tricks!(card_slug)
    else
      fail RunnerError.new("unknown action #{action}")
    end

    @broadcaster.info
    @broadcaster.make_remarks

    if @game.finished?
      @broadcaster.scores
    end

    @game
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def pick_king!(king_slug)
    @game.pick_king!(king_slug)

    if @game.king
      @broadcaster.king_picked
      advance!
    end
  end

  def pick_talon!(talon_half_index)
    @game.pick_talon!(talon_half_index)

    if @game.talon_picked
      @broadcaster.talon_picked
      advance!
    end
  end

  def pick_whole_talon!
    @game.pick_whole_talon!

    if @game.talon_picked
      advance!
    end
  end

  def resolve_talon!(discard_slugs)
    @game.resolve_talon!(discard_slugs)

    if @game.talon_resolved
      @broadcaster.talon_resolved
      advance!
    end
  end


  def advance_bidding!(bid_slug)
    bid = @game.bids.make_bid!(bid_slug)

    while bid
      @broadcaster.bid(bid: bid)
      bid = @game.bids.make_bid!
    end

    if @game.bids.finished?
      @broadcaster.bids_finished
      advance!
    end
  end

  def advance_announcements!(announcement_slug)
    announcement = @game.announcements.make_bid!(announcement_slug)

    while announcement
      @broadcaster.announcement(announcement: announcement)
      announcement = @game.announcements.make_bid!
    end

    if @game.announcements.finished?
      @broadcaster.announcements_finished
      advance!
    end
  end

  def advance_tricks!(card_slug)
    card = Card.find_by(game_id: @game.id, slug: card_slug)
    card = @game.tricks.play_card!(card)
    while card
      @broadcaster.card_played(card: card)
      card = @game.tricks.play_card!
    end
  end
end
