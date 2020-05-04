class PlayerPresenter
  attr_reader :player
  attr_accessor :active

  include Rails.application.routes.url_helpers  

  delegate(
    :announcements,
    :declarer?,
    :forehand?,
    :game_points,
    :human?,
    :id,
    :points,
    :position,
    :played_in_any_trick?,
    :played_in_current_trick?,
    :team_points,
    :winner?,
    :won_tricks,
    to: :player
  )

  def initialize(player, game)
    @player = player
    @game = game
    @player_teams = game.player_teams
  end

  def props(active_player)
    {
      id: @player.id,
      position: @player.position,
      compass: compass(active_player),
      name: @player.name,
      announcements_text: announcements_text,
      bids: bids,
      human: @player.human?,
      active: @player.id == active_player.id,
      play_as_path: edit_match_player_game_path(@game.match_id, @player.id, @game.id),
      next_to_play: @game.next_player&.id == @player.id,
      forehand: @player.forehand?,
      declarer: @game.declarer&.id == @player.id,
      known_partner: known_partner
    }
  end

  def compass(active_player)
    index = (@player.position - active_player.position) % 4
    ['south', 'east', 'north', 'west'][index]
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
    @player
      .announcements
      .select { |a| a.slug != 'pass' }
      .map { |a| AnnouncementPresenter.new(a.slug).shorthand }
      .join(" ")
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
