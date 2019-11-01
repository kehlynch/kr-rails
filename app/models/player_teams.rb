class PlayerTeams

  attr_reader :declarers, :defence, :teams

  delegate :find, :each, to: :teams

  def initialize(game)
    @game = game
    @king = @game.king
    @talon = @game.talon.unpicked
    @declarer = @game.declarer
    @bid = @game.bids.highest
    @trischaken = @bid&.trischaken?
    init_declarers
    init_defence

    @teams = [@declarers, @defence]
  end

  def init_declarers
    @declarers = [] if @trischaken
    players = [@declarer, partner].reject(&:nil?).uniq { |p| p.id }
    @declarers = PlayerTeam.new(players, game: @game, talon: @talon, bid: @bid, king: @king)
  end

  def init_defence
    @defence = [] if @trischaken
    players = @game.players.reject { |p| @declarers.map(&:id).include?(p.id) }
    @defence = PlayerTeam.new(players, game: @game, defence: true, talon: @talon, bid: @bid, king: @king)
  end

  def winners
    return trischaken_winners if @trischaken

    return defence.players if defence.winner?

    return declarers.players
  end

  def trischaken_winners
    return trischaken_zero_trick_winners if trischaken_zero_trick_winners.any?

    highest = @game.players.map { |p| Points.individual_points_for(p) }.max
    @game.players.select { |p| Points.individual_points_for(p) != highest }
  end

  def trischaken_zero_trick_winners
    @game.players.select { |p| Points.individual_points_for(p) == 0 }
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
      return loss * 2 if player.forehand_for?(@game.id)
      return loss
    elsif trischaken_zero_trick_winners.any?
      -1
    else
      loss = -(winners.length/(4 - winners.length))
      
      return loss * 2 if player.forehand_for?(@game.id)

      return loss
    end
  end

  def winner?(player)
    winners.map(&:id).include?(player.id)
  end

  def declarer?(player)
    @declarer.id == player.id
  end

  def declarer_or_partner?(player)
    declarers.map(&:id).include?(player.id)
  end

  def defence?(player)
    defence.map(&:id).include?(player.id)
  end

  def team_for(player)
    if declarer_or_partner?(player)
      declarers
    elsif defence?(player)
      defence
    end
  end

  def team_points_for(player)
    return Points.individual_points_for(player) if @trischaken

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
      
      return loss * 2 if player.forehand?

      return loss
    end
  end

  def partner
    @game.cards.find { |c| c.slug == @king }&.player
  end
end
