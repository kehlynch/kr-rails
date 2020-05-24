class PositiveGamePointsService
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
  end

  private

  def record_winners
    @game.game_players.each do |gp|
      gp.update(winner: winners.include?(gp))
    end
  end

  def game_points_for(gp)
    bid_points = @bid.points * @bid.kontra_multiplier
    team_announcement_points = announcment_points_for(gp.team)

    if gp.winner
      team_announcement_points + bid_points
    else
      team_announcement_points - bid_points
    end
  end

  def announcement_points_for(team_name)
    team_points = @game.announcement_scores.select { |as| as.team == team_name }.map(&:points).sum
    opposition_points = @game.announcement_scores.select { |as| as.team != team_name }.map(&:points).sum

    team_points - opposition_points
  end

  def winners
    declarers = @game.game_players.declarers
    defenders = @game.game_players.defenders
    declarers_card_points = declarers.map(&:card_points).sum

    defenders_card_points = defenders.map(&:card_points).sum

    if defenders_card_points >= declarers_card_points
      return defenders
    else
      return declarers
    end
  end
end
