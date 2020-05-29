class PlayerPresenter
  attr_reader :player

  include Rails.application.routes.url_helpers  

  delegate(
    :announcements,
    :card_points,
    :declarer?,
    :forehand?,
    :game_points,
    :human?,
    :id,
    :position,
    :team_points,
    :winner?,
    :won_tricks,
    to: :player
  )

  def initialize(player, game, active_player)
    @player = player
    @game = game
    @active_player = active_player
    @active = active_player.id == player.id
  end

  def props
    static_props
      .merge(indicator_props)
      .merge(announcements: @player.announcements.map { |a| Bids::AnnouncementPresenter.new(a.slug).shorthand }.join(' '))
  end

  def props_for_bids
    {
      id: @player.id,
      compass: compass,
      bids: Bids::BidsPresenter.names_for(@player.bids),
    }
  end

  def props_for_announcements
    {
      id: @player.id,
      compass: compass,
      bids: @player.announcements.map { |a| Bids::AnnouncementPresenter.new(a.slug).name }
    }
  end

  private

  def static_props
    {
      id: @player.id,
      play_as_path: edit_match_player_game_path(@game.match_id, @player.id, @game.id),
      compass: compass,
      name: @player.name,
      human: @player.human?,
      active: @active
    }
  end

  def indicator_props
    {
      next_to_play: @game.next_player&.id == @player.id,
      forehand: @player.forehand?,
      declarer: @game.declarer&.id == @player.id,
      known_partner: known_partner,
    }
  end

  def compass
    index = (@player.position - @active_player.position) % 4
    ['south', 'east', 'north', 'west'][index]
  end

  def name(you_if_human=true)
    return 'You' if you_if_human && @active
    player.name
  end

  def announcements_text
    @player
      .announcements
      .select { |a| a.slug != 'pass' }
      .map { |a| Bids::AnnouncementPresenter.new(a.slug).shorthand }
      .join(" ")
  end

  def won_tricks_count
    @player.won_tricks.size
  end

  def known_partner
    king_played = @game.cards.find do |c|
      c.trick_id.present? && c.slug == @game.king
    end.present?

    @game.partner&.id == @player&.id && (king_played || @active)
  end

  def role
    return 'declarer' if @game.declarer&.id == @player.id

    return 'partner' if @game.partner&.id == @player.id

    return ''
  end
end
