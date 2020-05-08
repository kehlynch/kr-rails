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
    @message_presenter = MessagePresenter.new(game)
    @remarks = Remarks.remarks_for(@game)
  end

  def props(visible_stage=nil)
    visible_stage ||= Stage.visible_stage_for(game, active_player)

    {
      paths: paths_props,
      channel: channel_props,
      action: stage,
      instruction: InstructionPresenter.new(@game, active_player, visible_stage).props,
      message: MessagePresenter.new(@game).props,
      remarks: @remarks,
      my_move: my_move?,
      bids: BidsPresenter.new(@game, active_player, visible_stage).props_for_bidding,
      announcements: AnnouncementsPresenter.new(@game, active_player, visible_stage).props_for_bidding,
      visible_stage: visible_stage,
      talon: TalonPresenter.new(talon, active_player, declarer, talon_picked, visible_stage).props,
      tricks: TricksPresenter.new(@game, active_player, visible_stage).props,
      playable_trick_index: tricks.playable_trick_index,
      declarer_name: declarer&.name,
      is_declarer: declarer&.id == @active_player_id,
      king_needed: bids.pick_king?,
      picked_king_slug: king,
      player_position: active_player.position,
      talon_picked: talon_picked,
      talon_cards_to_pick: bids.talon_cards_to_pick,
      won_bid: bids.finished? && bids.highest&.slug,
      kings: KingsPresenter.new(@game, active_player, visible_stage).props,
      players: PlayersPresenter.new(@game, active_player, visible_stage).props,
      hand: HandPresenter.new(@game, active_player, visible_stage).props,
      points: Points::MatchPointsPresenter.new(@game.match, active_player, visible_stage).props
    }
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
      next_hand_path: next_match_player_game_path(@game.match_id, @active_player_id, @game.id),
      advance_path: advance_match_player_game_path(@game.match_id, @active_player_id, @game.id)
    }
  end

  def model
    @game
  end

  def forehand
    @players.find { |p| p.forehand? }
  end

  def active_player
    @game.players.find { |p| p.id == @active_player_id }
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
end
