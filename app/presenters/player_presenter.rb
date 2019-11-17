class PlayerPresenter
  attr_reader :player
  attr_accessor :active

  delegate :declarer?, :forehand?, :human?, :position, :id, :announcements, :points, :team_points, :game_points, :winner?, to: :player

  def initialize(player, game)
    @player = player
    @game = game
    @player_teams = game.player_teams
  end

  def hand
    HandPresenter.new(@player.hand).sorted
  end

  def active?
    active
  end

  def name(you_if_human=true)
    return 'You' if you_if_human && active
    player.name
  end

  def bids
    @player.bids.map { |b| BidPresenter.new(b.slug).name }
  end

  def announcements_text
    @player.announcements.map { |a| AnnouncementPresenter.new(a.slug).shorthand }.join(" ")
  end

  def won_tricks_count
    @player.won_tricks.count
  end

  def known_partner
    king_played = @game.cards.find do |c|
      c.trick_id.present? && c.slug == @game.king
    end.present?
    @game.partner&.id == @player&.id && (king_played || active?)
  end

  def role
    return 'declarer' if @game.declarer&.id == @player.id

    return 'partner' if @game.partner&.id == @player.id

    return ''
  end
end
