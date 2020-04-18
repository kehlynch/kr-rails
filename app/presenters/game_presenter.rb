class GamePresenter
  attr_reader :game, :players

  delegate(
    :announcements,
    :bids,
    :cards,
    :current_trick,
    :declarer,
    :declarer_human?,
    :finished?,
    :id,
    :king,
    :next_player,
    :next_player_human?,
    :partner,
    :player_teams,
    :stage,
    :talon,
    :talon_picked,
    :tricks,
    :winners,
    to: :game
  )

  def initialize(game, active_player_id)
    @game = game
    @active_player_id = active_player_id
    @players = PlayersPresenter.new(game, active_player_id)
    @announcements = game.announcements.map { |a| AnnouncementPresenter.new(game) }
  end

  def model
    @game
  end

  def forehand
    @players.find { |p| p.forehand? }
  end

  def active_player
    @players.find { |p| p.id == @active_player_id }
  end

  def my_move?
    # next_player is nil if the game is finished
    @active_player_id == next_player&.id
  end

  def talon_pickable?
    declarer&.id == @active_player_id && stage == 'pick_talon'
  end

  def valid_announcements
    @game.announcements.valid_announcements.map do |slug|
      [slug, AnnouncementPresenter.new(slug).name]
    end
  end

  def summary
    return nil unless @game.finished?

    {
      bid: bid_summary,
      announcements: announcements_summary,
      players: players_summary
    }
  end

  def players_summary
    points = game
      .match
      .games
      .select { |g| g.id <= @game.id }
      .map { |g| GamePresenter.new(g, @active_player_id) }
      .map(&:raw_points)
      .reduce([0, 0, 0, 0]) do |raw_points, acc|
        acc.each_with_index.map { |p, i| p + raw_points[i] }
      end

    @players.each_with_index.map do |player, i|
      {
        points: points[i],
        forehand: player.forehand?,
        winner: @game.winners.map(&:id).include?(player.id),
        declarer: @game.declarer.id == player.id
      }
    end
  end

  def announcements_summary
    Announcements::SLUGS.map do |slug|
      announcement_summary(slug)
    end.flatten
  end

  def announcement_summary(slug)
    @game.player_teams.map do |team|
      next unless team.made_announcement?(slug) || team.lost_announcement?(slug)

      {
        shorthand: AnnouncementPresenter.new(slug).shorthand,
        kontra: team.announcement(slug)&.kontra || false,
        off: team.lost_announcement?(slug),
        defence: team.defence?,
        declared: team.announced?(slug)
      }
    end.compact
  end

  def bid_summary
    winning_bid = @game.bids.highest
    {
      kontra: winning_bid.kontra,
      off: !@game.winners.include?(@game.declarer),
      shorthand: BidPresenter.new(winning_bid.slug).shorthand,
      vs_three:  @game.player_teams.defence.length == 3 && @game.bids&.highest&.king?
    }
  end

  def raw_points
    return [] unless @game.finished?

    @players.map(&:game_points)
  end

  def show_king?
    return false if [Stage::BID, Stage::TRICK, Stage::FINISHED].include?(stage)

    return false unless active_player.announcements.blank?

    return false unless @game.bids.pick_king?

    return true
  end

  def show_talon?
    return false if [Stage::BID, Stage::KING, Stage::TRICK, Stage::FINISHED].include?(stage)

    return false unless active_player.announcements.blank?

    return false unless @game.bids.talon_cards_to_pick.present?

    return true
  end

  def show_penultimate_trick?
    return false unless stage == Stage::TRICK

    return false if active_player.played_in_current_trick?
    
    return false if @game.tricks.current_trick&.finished?

    return false if @game.tricks.count < 2

    return true
  end

  def visible_step
    return 'finished' if stage == Stage::FINISHED

    return 'trick' if (active_player.played_in_any_trick? || active_player.declarer?) && stage == Stage::TRICK

    return 'announcement' if (active_player.announcements.any? || active_player.declarer?) && [Stage::TRICK, Stage::ANNOUNCEMENT].include?(stage)

    return 'pick_talon' if active_player.declarer? && stage == Stage::PICK_TALON

    return 'pick_whole_talon' if active_player.declarer? && stage == Stage::PICK_WHOLE_TALON

    return 'resolve_talon' if active_player.declarer? && stage == Stage::RESOLVE_TALON

    return 'resolve_whole_talon' if active_player.declarer? && stage == Stage:: RESOLVE_WHOLE_TALON

    # show the king being picked if we're not declarer
    return 'king' if [Stage::KING, Stage::ANNOUNCEMENT].include?(stage)

    return 'bid'
  end
end
