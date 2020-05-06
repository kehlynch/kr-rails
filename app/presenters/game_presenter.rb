class GamePresenter
  attr_reader :game, :players

  include Rails.application.routes.url_helpers  

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
    @message_presenter = MessagePresenter.new(game)
    @remarks = Remarks.remarks_for(@game)
  end

  def props
    {
      paths: paths_props,
      channel: channel_props,
      action: stage,
      instruction: @message_presenter.instruction_msg(active_player),
      message: MessagePresenter.new(@game).props,
      remarks: @remarks,
      my_move: my_move?,
      valid_bids: valid_bids_props,
      valid_announcements: AnnouncementsPresenter.new(@game).props_for_bidding,
      visible_stage: visible_stage,
      talon: TalonPresenter.new(talon, active_player, declarer, talon_picked, visible_stage).props,
      tricks: TricksPresenter.new(tricks, active_player).props,
      playable_trick_index: tricks.playable_trick_index,
      visible_trick_index: visible_trick_index,
      declarer_name: declarer&.name,
      is_declarer: declarer&.id == @active_player_id,
      king_needed: bids.pick_king?,
      picked_king_slug: king,
      player_position: active_player.position,
      talon_picked: talon_picked,
      talon_cards_to_pick: bids.talon_cards_to_pick,
      won_bid: bids.highest&.slug,
      continue_available: continue_available?,
      kings: kings_props,
      players: players_props,
      hand: hand_props,
      points: Points::MatchPointsPresenter.new(@game.match, active_player, visible_stage).props
    }
  end

  def hand_props
    active_player.hand.map do |card|
      CardPresenter.new(card, active_player).hand_props(stage)
    end
  end

  def players_props
    # TODO get rid of the @players using PlayersPresneter
    game.players.map do |player|
      PlayerPresenter.new(player, game).props(active_player)
    end
  end

  def kings_props
    ['club_8', 'diamond_8', 'heart_8', 'spade_8'].map do |king_slug|
      {
        slug: king_slug,
        own_king: declarer&.hand&.find { |c| c.slug == king_slug }.present?,
        pickable: active_player.declarer?,
        picked: king == king_slug
      }
    end
  end

  def channel_props
    {
      channel: 'PlayersChannel',
      player_id: @active_player_id,
      game_id: @game.id
    }
  end

  def paths_props
    {
      update_path: match_player_game_path(@game.match_id, @active_player_id, @game.id),
      new_single_player_path: matches_path(match: { human_count: 1 }),
      reset_path: reset_match_player_game_path(@game.match_id, @active_player_id, @game.id),
      next_hand_path: next_match_player_game_path(@game.match_id, @active_player_id, @game.id)
    }
  end

  def valid_bids_props
    @game.bids.valid_bids.map do |slug|
      {
        slug: slug,
        name: BidPresenter.new(slug).name
      }
    end
  end

  def visible_trick_index
    show_penultimate_trick? ? tricks.playable_trick_index - 1 : tricks.playable_trick_index
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

  def continue_available?
    show_penultimate_trick? || (visible_stage != @game.stage)
  end

  def visible_stage
    return stage if stage == Stage::FINISHED

    # show the announcement results if we haven't played a card yet
    return stage if active_player.played_in_any_trick? && stage == Stage::TRICK

    # show the bid results unless we're declarer or have already made an announcement
    # return Stage::BID unless active_player.declarer? || active_player.announcements.any?

    return stage
  end
end
