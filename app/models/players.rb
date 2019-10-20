class Players

  attr_reader :players

  delegate :[], :each, :map, :reject, to: :players

  def initialize(game_id)
    @game_id = game_id
    @players = Player.where(game_id: game_id).sort_by(&:position)
  end

  def winner
    @players.max_by(&:points)
  end

  def human_player
    @players.find { |p| p.human }
  end

  def forehand
    human_player
  end

  def next_from(player)
    Player.find_by(game_id: @game_id, position: (player.position + 1) % 4)
  end
end
