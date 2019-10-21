class PlayerPresenter
  attr_reader :player

  delegate :human?, :position, :id, :game_points_for, :forehand_for?, :winner_for?, :declarer_for?, :bids_for, to: :player

  def initialize(player, game_id)
    @game_id = game_id
    @player = player
    @game = Game.find(game_id)
    @player_teams = PlayerTeams.new(game_id)
  end

  def name(you_if_human=true)
    return 'You' if you_if_human && human?
    ['Katherine', 'Mary', 'David', 'Clare'][position]
  end

  def bids
    @player.bids_for(@game_id).map { |b| BidPresenter.new(b.slug).name }
  end

  def won_tricks_count
    @player.won_tricks_for(@game.id).count
  end

  def winner?
    @player_teams.winner?(@player)
  end

  def points
    Points.individual_points_for(@player, @game_id)
  end

  def team_points
    @player_teams.team_points_for(@player)
  end

  def game_points
    @player_teams.game_points_for(@player)
  end

  def known_partner
    king_played = Card.where.not(trick_id: nil).find_by(game_id: @game.id, slug: @game.king)
    @game.partner == @player && king_played
  end

  def role
    return 'declarer' if @game.declarer == @player

    return 'partner' if @game.partner == @player

    return ''
  end
end
