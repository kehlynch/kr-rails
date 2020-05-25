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

  def update_bid_result
    @game.won_bid.update(off: bid_off?)
  end

  def record_winners
    @game.game_players.each do |gp|
      gp.update(winner: winners.include?(gp))
    end
  end

  def game_points_for(gp)
    bid_points = @bid.points * @bid.kontra_multiplier # 3
    bid_points = bid_points * 2 if off_double?
    team_announcement_points = announcement_points_for(gp.team) # 0

    team_count = gp.team_members.count # 1 -- 3
    opposition_count = 4 - team_count # 3 -- 1
    points_swing = gp.winner ?  team_announcement_points + bid_points : team_announcement_points - bid_points # 3 -- -3

    points_swing * opposition_count # 9
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

  def off_double?
    @bid.slug == Bid::SECHSERDREIER && bid_off?
  end

  def bid_off?
    declarers_card_points = declarers.map(&:card_points).sum

    defenders_card_points = defenders.map(&:card_points).sum

    defenders_card_points >= declarers_card_points
  end

  def declarers
    @game.game_players.declarers
  end

  def defenders
    @game.game_players.defenders
  end
end
