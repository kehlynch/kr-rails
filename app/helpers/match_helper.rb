module MatchHelper
  def match_points(match_games)
    points = match_games.map do |game|
      game.players.map do |p|
        points = p.game_points_for(game.id)
      end
    end

    acc_points = points.each_with_index.map do |game_points, game_index|
        game_points.each_with_index.map do |p, player_index|
          points[0..game_index].map { |p| p[player_index] }.sum
        end
      end

    acc_points
  end

  def bid_shorthand(game)
    winning_bid = Bids.new(game.id).highest
    BidPresenter.new(winning_bid.slug).shorthand
  end

  def points_classes(player, game_id)
    forehand_class = player.forehand_for?(game_id) ? 'forehand' : ''
    winner_class = player.winner_for?(game_id) ? 'winner' : ''
    declarer_class = player.declarer_for?(game_id) ? 'declarer' : ''
    
    [forehand_class, winner_class, declarer_class].join(' ')
  end

  def bid_classes(game)
    'off' if !game.winners.include?(game.forehand)
  end
end
