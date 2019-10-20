class PlayerTeam
  attr_reader :players
  delegate :include?, to: :players

  def initialize(players, talon:, bid:, defence: false)
    @players = players
    @defence = defence
    @talon = talon
    @bid = bid
  end

  def points
    return @points if @points

    p '@players'
    p @players

    cards = @players.map(&:scorable_cards).flatten

    cards = cards + @talon if @defence

    @points = Points.points_for_cards(cards)
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
