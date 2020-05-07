class BidsPresenter
  def self.names_for(bids)
    bids.map do |bid|
      BidPresenter.new(bid.slug).name
    end
  end

  def initialize(game, active_player, visible_stage)
    @game = game
    @active_player = active_player
    @visible_stage = visible_stage
  end

  def props_for_bidding
    {
      visible: @visible_stage == Stage::BID,
      bid_picker_visible: @visible_stage == Stage::BID && !@game.bids.finished?,
      finished: @game.bids.finished?,
      finished_message: finished_message,
      instruction: instruction,
      valid_bids: valid_bids_props
    }
  end

  private

  def instruction
    return 'bidding finished, click to continue' if @game.bids.finished?

    return 'make a bid' if @game.next_player.id == @active_player.id

    "waiting for #{@game.next_player.name} to make a bid"
  end

  def finished_message
    return nil unless @game.bids.finished?

    "#{@game.declarer.name} wins bidding with #{BidPresenter.new(@game.bids.highest.slug).name}"
  end

  def valid_bids_props
    @game.bids.valid_bids.map do |slug|
      valid_bid_props(slug)
    end
  end

  def valid_bid_props(slug)
    {
      slug: slug,
      name: BidPresenter.new(slug).name
    }
  end
end
