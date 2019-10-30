class PlayerPresenter
  attr_reader :player

  delegate :forehand_for?, :human?, :position, :id, :announcements, :points, :team_points, :game_points, :winner?, to: :player

  def initialize(player, game)
    @player = player
    @game = game
    @player_teams = game.player_teams
  end

  def name(you_if_human=true)
    return 'You' if you_if_human && human?
    ['Katherine', 'Mary', 'David', 'Clare'][position]
  end

  def bids
    @player.bids.map { |b| BidPresenter.new(b.slug).name }
  end

  def announcements_text
    @player.announcements.map { |b| AnnouncementPresenter.new(b.slug).shorthand }.join(" ")
  end

  def won_tricks_count
    @player.won_tricks.count
  end

  def known_partner
    king_played = Card.where.not(trick_id: nil).find_by(game_id: @game.id, slug: @game.king)
    @game.partner&.id == @player&.id && king_played
  end

  def role
    return 'declarer' if @game.declarer == @player

    return 'partner' if @game.partner == @player

    return ''
  end
end
