class Points::NegativeGamePointsService
  def initialize(game)
    @game = game
    @bid = game.bids.highest

  end

  def record_game_points
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

  def game_points_for(game_player)
    # this class is just for bettel/piccolo - always vs 3. And no announcements except kontra (don't think this is implemented event) to worry about
    points_swing = @bid.points * @bid.kontra_multiplier * 3
    team_points = winner?(game_player) ? points_swing : -points_swing
    team_size = game_player.team_members.size

    team_points / team_size
  end

  def winner?(game_player)
    trick_count = @bid.contracted_trick_count
    if game_player.team == GamePlayer::Defenders
      game_player.tricks.length != (12 - trick_count)
    else
      game_player.tricks.length == trick_count
    end
  end

  def bid_off?
    trick_count = @bid.contracted_trick_count
    @game.declarer.tricks.length != (12 - trick_count)
  end
end
