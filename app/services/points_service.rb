class PointsService
  def initialize(game)
    @game = game
    @bid = game.bids.highest
  end

  def record_points
    record_card_points

    if @bid.trischaken?
      Points::TrischakenGamePointsService.new(@game).record_game_points
    elsif @bids.negative?
      Points::NegativeGamePointsService.new(@game).record_game_points
    else
      create_announcement_scores
      Points::PositiveGamePointsService.new(@game).record_game_points
    end
  end

  private

  attr_reader :game

  delegate(:game_players, to: game)
  delegate(:defenders, :declarers, to: game_players)

  def create_announcement_scores
    [GamePlayer::DEFENDERS, GamePlayer::DECLARERS].each do |team_name|
      team = game_players.select { |gp| gp.team == team_name }
      Points::AnnouncementScoresService.new(@game, team).create_announcement_scores
    end
  end

  def record_card_points
    @game.game_players.each do |gp|
      card_points = card_point_for(gp.tricks.cards)
      gp.update(card_points: card_points)
    end
  end

  def card_points_for(cards)
    cards.map(&:points).in_groups_of(3).reduce(0) do |acc, group|
      group.compact!
      total = group.length > 1 ? group.sum + 1 : group.sum
      acc + total
    end
  end

  def record_game_points
    @game.game_players.each do |gp|
      game_points = game_point_for(gp)
      gp.update(game_points: game_points)
    end
  end
end
