class Points::GamePointsShorthandsPresenter
  def initialize(game)
    @game = game
  end

  def props
    {
      id: "game-shorthands-#{@game.id}",
      bid: bid_props,
      announcements: announcements_props
    }
  end

  private

  def bid_props
    won_bid = @game.won_bid
    {
      id: "js-points-bid-#{@game.id}",
      shorthand: won_bid && Bids::BidPresenter.new(won_bid.slug).shorthand,
      classes: classlist(
        kontra: won_bid&.kontra,
        off: won_bid&.off,
        vs_three:  @game.defenders.count == 3 && won_bid&.king?
      ).join(' ')
    }
  end

  def announcements_props
    @game.announcement_scores.map do |announcement_score|
      announcement_props_for_points(announcement_score)
    end
  end

  def announcement_props_for_points(a)
    {
      shorthand: Bids::AnnouncementPresenter.new(a.slug).shorthand,
      classes: classlist(
        kontra: a.kontra,
        off: a.off,
        defence: a.team == GamePlayer::DEFENDERS,
        declared: a.declared
      ).join(' ')
    }
  end

  def classlist(**args)
    args[:kontra] = kontra_class(args[:kontra])
    args.select{ |_k, v| v }.keys
  end

  def kontra_class(kontra)
    { 2 => 'kontra', 4 => 'rekontra', 8 => 'subkontra' }[kontra]
  end
end
