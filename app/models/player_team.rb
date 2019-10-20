class PlayerTeam
  attr_reader :players
  delegate :include?, to: :players

  def initialize(players, game_id:, talon:, bid:, king:, defence: false)
    @game_id = game_id
    @players = players
    @talon = talon
    @bid = bid
    @defence = defence
    @king = king
  end

  def points
    cards = @players.map { |p| p.scorable_cards_for(@game_id) }.flatten

    cards = cards + @talon if score_talon?

    Points.points_for_cards(cards)
  end

  def score_talon?
    return !@defence if @bid.slug == 'solo' && @talon.find { |c| c.slug == @king }

    return @defence
  end

  def winner?
    return points >= 35 if @defence

    return points >= 36
  end

  def game_points
    defence_count = @defence ? @players.length : 4 - @players.length
    total_points = @bid.points * defence_count
    points_per_player = total_points/@players.length

    return points_per_player if winner?

    return points_per_player * -1
  end

  private
end
