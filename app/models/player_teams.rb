class PlayerTeams
  def initialize(game_id)
    @game_id = game_id
    @game = Game.find(game_id)
    @king = @game.king
    @talon = @game.talon.unpicked
    @declarer = @game.declarer
    @bid = @game.bids.highest
    @trischaken = @bid&.trischaken?
  end

  def declarers
    return [] if @trischaken
    players = [@declarer, partner].reject(&:nil?).uniq
    PlayerTeam.new(players, talon: @talon, bid: @bid, king: @king, game_id: @game_id)
  end

  def defence
    return [] if @trischaken
    players = @game.players.reject { |p| declarers.include?(p) }
    PlayerTeam.new(players, defence: true, talon: @talon, bid: @bid, king: @king, game_id: @game_id)
  end

  def winners
    return trischaken_winners if @trischaken

    return defence if defence.winner?

    return declarers
  end

  def trischaken_winners
    return trischaken_zero_trick_winners if trischaken_zero_trick_winners.any?

    highest = @game.players.map { |p| p.individual_points_for(@game_id) }.max
    @game.players.select { |p| p.individual_points_for(@game_id) != highest }
  end

  def trischaken_zero_trick_winners
    @game.players.select { |p| p.individual_points_for(@game_id) == 0 }
  end

  def winner?(player)
    winners.include?(player)
  end

  def declarer?(player)
    @declarer == player
  end

  def team_for(player)
    if declarers.include?(player)
      declarers
    else
      defence
    end
  end

  def team_points_for(player)
    return player.individual_points_for(@game_id) if @trischaken

    team_for(player).points
  end
 
  def game_points_for(player)
    return trischaken_game_points_for(player) if @trischaken

    team_for(player).game_points
  end

  def trischaken_game_points_for(player)
    if trischaken_zero_trick_winners.include?(player)
      (4 - winners.length)/winners.length
    elsif winners.include?(player)
      loss = 1
      return loss * 2 if !winners.include?(@game.forehand)
      return loss
    elsif trischaken_zero_trick_winners.any?
      -1
    else
      loss = -(winners.length/(4 - winners.length))
      
      return loss * 2 if player.forehand_for?(@game_id)

      return loss
    end
  end

  def partner
    Card.find_by(slug: @king, game_id: @game_id)&.player
  end
end
