class PointsService
  def initialize(game)
    @game = game
    @bid = game.winning_bid
  end

  def record_points
    record_card_points

    if @bid.trischaken?
      Points::TrischakenGamePointsService.new(@game).record_game_points
    elsif @bid.negative?
      Points::NegativeGamePointsService.new(@game).record_game_points
    else
      @game.announcement_scores.destroy_all
      create_announcement_scores
      Points::PositiveGamePointsService.new(@game).record_game_points
    end
  end

  private

  attr_reader :game

  delegate(:game_players, to: :game)
  delegate(:defenders, :declarers, to: :game_players)

  def create_announcement_scores
    [GamePlayer::DEFENDERS, GamePlayer::DECLARERS].each do |team_name|
      team = game_players.where(team: team_name)
      Points::AnnouncementScoresService.new(@game, team, team_name).create_announcement_scores
    end
  end

  def record_card_points
    @game.game_players.each do |gp|
      card_points = card_points_for(gp.scorable_cards)
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
end
