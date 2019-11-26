# A class responsible for sending commands to the game
# and announcing the results
# Pass it an action from the active player and it
# will make all the computer player moves happen and announce the results
class Runner
  def initialize(game)
    @game = game
    @broadcaster = Broadcaster.new(game)
  end
  
  def advance!(action:, **params)
    case action
      when 'make_bid'
        advance_bidding!(params[:make_bid])
      when 'pick_king'
        @game.pick_king!(params[:pick_king])
        @broadcaster.king_picked
      when 'pick_talon'
        talon_half_index = params[:pick_talon].to_i
        @game.pick_talon!(talon_half_index)
        @broadcaster.talon_picked(talon_half_index)
      when 'pick_whole_talon'
        @game.pick_whole_talon!
      when 'resolve_talon'
        @game.resolve_talon!(params[:resolve_talon])
      when 'resolve_whole_talon'
        @game.resolve_talon!(params[:resolve_whole_talon])
      when 'make_announcement'
        advance_announcements!(params[:make_announcement])
        @game.make_announcements!(params[:make_announcement])
      when 'play_card'
        card_slug = params[:play_card][0] if params[:play_card]
        advance_tricks!(card_slug)
      when 'next_trick'
        raise 'not doing next_trick anymore'
      else
        raise "unknown action #{action}"
    end

    @broadcaster.info

    if @game.finished?
      @broadcaster.scores
    end
  end

  private

  def advance_bidding!(bid_slug)
    bid = @game.bids.make_bid!(bid_slug)
    while bid
      @broadcaster.bid(bid: bid)
      bid = @game.bids.make_bid!
    end
    
    @broadcaster.bids_finished if @game.bids.finished?
  end

  def advance_announcements!(announcement_slugs)
    announcements = @game.announcements.make_announcements!(announcement_slugs)
    while announcements
      announcements.each do |a|
        @broadcaster.announcement(announcement: a)
      end
      announcements = @game.announcements.make_announcements!
    end
    
    @broadcaster.announcements_finished if @game.announcements.finished?
  end

  def advance_tricks!(card_slug)
    p '***advance_tricks', 
    card = Card.find_by(game_id: @game.id, slug: card_slug)
    card = @game.tricks.play_card!(card)
    while card
      @broadcaster.card_played(card: card)
      card = @game.tricks.play_card!
    end
  end
end