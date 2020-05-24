class TrischakenGamePointsService
  def initialize(game)
    @game = game
  end

  def record_game_points
    @game.game_players.each do |gp|
      game_points = game_points_for(gp)
      gp.update(game_points: game_points)
    end
  end

  private

  def game_points_for(player)
    if zero_trick_winners.any?
      return (4 - winners.length) / winners.length if zero_trick_winners.include?(player)

      -1
    else
      if winners.include?(player)
        return 2 unless winners.include?(@game.forehand)

        return 1
      else
        loss = -(winners.length / (4 - winners.length))

        return loss * 2 if player.forehand?

        return loss
      end
    end

  end

  def winners
    return zero_trick_winners if zero_trick_winners.any?

    most_points = @game.game_players.max(:card_points)
    @game.game_players.reject { |gp| gp.card_points == most_points }
  end


  def zero_trick_winners
    @game.game_players.select { |gp| gp.card_points == 0 }
  end
end
