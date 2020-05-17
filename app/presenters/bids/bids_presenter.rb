class Bids::BidsPresenter < Bids::BidsBasePresenter
  def self.names_for(bids)
    bids.map do |bid|
      Bids::BidPresenter.new(bid.slug).name
    end
  end

  private

  def stage
    Stage::BID
  end

  def finished?
    @game.bids.finished?
  end

  def finished_message
    return nil unless @game.bids.finished?

    "#{@game.declarer.name} wins bidding with #{Bids::BidPresenter.new(@game.bids.highest.slug).name(declared: true)}"
  end

  def biddable_props
    @game.bids.valid_bids.map do |slug|
      {
        slug: slug,
        name: Bids::BidPresenter.new(slug).name
      }
    end
  end

  def players_props
    PlayersPresenter.new(@game, @active_player).props_for_bids
  end

  def hand_props
    HandPresenter.new(@game, @active_player).props_for_bids
  end

  def instruction
    return 'bidding finished, click to continue' if @game.bids.finished?

    return 'make a bid' if @game.next_player.id == @active_player.id

    "waiting for #{@game.next_player.name} to make a bid"
  end
end
