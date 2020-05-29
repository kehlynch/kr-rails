class Points::PositiveGamePointsService
  def initialize(game)
    @game = game
    @bid = game.bids.highest
  end

  def record_game_points
    record_winners
    @game.game_players.each do |gp|
      game_points = game_points_for(gp)
      gp.update(game_points: game_points)
    end

    update_bid_result
  end

  private

  attr_reader :game
  delegate(:declarers, :defenders, to: :game)

  def update_bid_result
    @game.won_bid.update(off: bid_off?)
  end

  def record_winners
    @game.game_players.each do |gp|
      gp.update(winner: winners.include?(gp))
    end
  end

  def game_points_for(gp)
    bid_points = @bid.points * @bid.kontra_multiplier # 1 / 1
    bid_points = bid_points * 2 if off_double? # 1 / 1
    team_announcement_points = announcement_points_for(gp.team) # -3 / 3

    points_swing = gp.winner ?  team_announcement_points + bid_points : team_announcement_points - bid_points # -4 / 4

    defenders_count = defenders.size # 3 / 3
    team_count = gp.team_members.size # 3 / 1
    (points_swing * defenders_count) / team_count # -4 / 12
  end

  def announcement_points_for(team_name)
    team_points = @game.announcement_scores.select { |as| as.team == team_name }.map(&:points).sum
    opposition_points = @game.announcement_scores.select { |as| as.team != team_name }.map(&:points).sum

    team_points - opposition_points
  end

  def winners
    if bid_off?
      return defenders
    else
      return declarers
    end
  end

  def declarer_count
    declarers.size
  end

  def off_double?
    @bid.slug == Bid::SECHSERDREIER && bid_off?
  end

  def bid_off?
    declarers_card_points = declarers.map(&:card_points).sum

    defenders_card_points = defenders.map(&:card_points).sum

    defenders_card_points >= declarers_card_points
  end
end
