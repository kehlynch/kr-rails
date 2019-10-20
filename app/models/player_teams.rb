class PlayerTeams
  def initialize(game_id)
    @game_id = game_id
    @game = Game.find(game_id)
    @king = @game.king
    @talon = @game.talon.unpicked
    @declarer = @game.declarer
    @bid = @game.bids.highest
  end

  def declarers
    players = [@declarer, partner].reject(&:nil?).uniq
    PlayerTeam.new(players, talon: @talon, bid: @bid, king: @king, game_id: @game_id)
  end

  def defence
    players = @game.players.reject { |p| declarers.include?(p) }
    PlayerTeam.new(players, defence: true, talon: @talon, bid: @bid, king: @king, game_id: @game_id)
  end

  def winners
    return defence if defence.winner?

    return declarers
  end

  def winner?(player)
    winners.include?(player)
  end

  def team_for(player)
    if declarers.include?(player)
      declarers
    else
      defence
    end
  end

  def team_points_for(player)
    team_for(player).points
  end
 
  def game_points_for(player)
    team_for(player).game_points
  end

  def partner
    Card.find_by(slug: @king, game_id: @game_id)&.player
  end
end
