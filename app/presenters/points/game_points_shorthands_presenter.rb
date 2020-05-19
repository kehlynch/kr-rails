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
    winning_bid = @game.bids.highest
    {
      id: "js-points-bid-#{@game.id}",
      shorthand: Bids::BidPresenter.new(winning_bid.slug).shorthand,
      classes: classlist(
        kontra: winning_bid.kontra,
        off: !@game.winners.include?(@game.declarer),
        vs_three:  @game.player_teams.defence.length == 3 && @game.bids&.highest&.king?
      ).join(' ')
    }
  end

  def announcements_props
    Announcements::SLUGS.map do |slug|
      announcement_props_for_points(slug)
    end.flatten
  end

  def announcement_props_for_points(slug)
    @game.player_teams.map do |team|
      next unless team.made_announcement?(slug) || team.lost_announcement?(slug)

      {
        shorthand: Bids::AnnouncementPresenter.new(slug).shorthand,
        classes: classlist(
          kontra: team.announcement(slug)&.kontra || false,
          off: team.lost_announcement?(slug),
          defence: team.defence?,
          declared: team.announced?(slug)
        ).join(' ')
      }
    end.compact
  end

  def classlist(**args)
    args[:kontra] = kontra_class(args[:kontra])
    args.select{ |_k, v| v }.keys
  end

  def kontra_class(kontra)
    { 2 => 'kontra', 4 => 'rekontra', 8 => 'subkontra' }[kontra]
  end
end


