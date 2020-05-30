# A class responsible for sending commands to the game
# and announcing the results
# Pass it an action from the active player and it
# will make all the computer player moves happen and announce the results
class Runner
  class RunnerError < StandardError; end

  def initialize(game, active_player_id=nil)
    @game = game
  end

  def advance!(**params)
    p 'advance!', params, @game.stage

    case @game.stage
    when Stage::BID
      advance_bidding!(params[Stage::BID])
    when Stage::KING
      pick_king!(params[Stage::KING])
    when Stage::PICK_TALON
      pick_talon!(params[Stage::PICK_TALON])
    when Stage::RESOLVE_TALON
      resolve_talon!(params[Stage::RESOLVE_TALON])
    when Stage::ANNOUNCEMENT
      advance_announcements!(params[Stage::ANNOUNCEMENT])
    when Stage::TRICK
      card_slug = params[Stage::TRICK][0] if params[Stage::TRICK]
      advance_tricks!(card_slug)
    when Stage::FINISHED
    else
      fail RunnerError.new("unknown action #{action}")
    end

    @game
  end

  private

  def advance_bidding!(bid_slug)
    bid = @game.make_bid!(bid_slug)

    while bid
      broadcast
      bid = @game.make_bid!
    end

    # maybe ned this cos won_bid hasn't been recorded - haven't checked - it's all too slow atm!
    # @game.reload
    if @game.won_bid.present?
      advance!
    end
  end

  def pick_king!(king_slug)
    @game.pick_king!(king_slug)
    broadcast

    if @game.king
      advance!
    end
  end

  def pick_talon!(talon_half_index)
    @game.pick_talon!(talon_half_index&.to_i)

    if @game.talon_picked
      broadcast
      advance!
    end
  end

  def resolve_talon!(discard_slugs)
    @game.resolve_talon!(discard_slugs)

    if @game.talon_resolved
      broadcast
      advance!
    end
  end

  def advance_announcements!(announcement_slug)
    announcement = @game.make_announcement!(announcement_slug)

    while announcement
      broadcast
      announcement = @game.make_announcement!
    end

    if @game.announcements_finished?
      advance!
    end
  end

  def advance_tricks!(card_slug)
    card = Card.find_by(game_id: @game.id, slug: card_slug)
    card = @game.play_card!(card)
    broadcast
    while card
      card = @game.play_card!
      broadcast
    end
  end

  def broadcast
    Broadcaster.broadcast(@game)
  end
end
