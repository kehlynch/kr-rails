class GamePlayers
  attr_reader :players

  delegate :[], :each, :map, :select, :reject, :find, :max_by, :first, :each_with_index, to: :players

  def initialize(game)
    @game = game
    @players = game.match.players.order(:position).map do |p|
      GamePlayer.new(p, game)
    end
  end

  def winner
    @players.max_by(&:points)
  end

  def human_player
    @players.find { |p| p.human? }
  end

  def forehand
    @players.find(&:forehand?)
  end

  def next_from(player)
    @players.find do |p|
      p.position == (player.position + 1) % 4
    end
  end
end
