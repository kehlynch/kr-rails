class Players

  attr_reader :players

  delegate :[], :each, :map, :select, :reject, to: :players

  def initialize(game_id)
    @game_id = game_id
    @match_id = Game.find(game_id).match_id
    @players = Player.where(match_id: @match_id).sort_by(&:position)
  end

  def winner
    @players.max_by(&:points)
  end

  def human_player
    @players.find { |p| p.human }
  end

  def forehand
    @players.find { |p| p.forehand_for?(@game_id) }
  end

  def next_from(player)
    Player.find_by(match_id: @match_id, position: (player.position + 1) % 4)
  end
end
