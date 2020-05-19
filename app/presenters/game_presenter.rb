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
    @active_player = game.game_players.find_by(player_id: active_player_id)
    @message_presenter = MessagePresenter.new(game)
    @remarks = Remarks.remarks_for(@game)
  end

  def props(visible_stage=nil)
    visible_stage ||= Stage.visible_stage_for(game, @active_player)

    {
      paths: paths_props,
      channel: channel_props,
      players: PlayersPresenter.new(@game, @active_player).static_props,
      contract: ContractPresenter.new(@game).props,
      stages: @game.stages,
      visible_stage: visible_stage,
      visible_trick_index: visible_trick_index
    }.merge(stage_props(visible_stage))
  end

  def stage_props(visible_stage)
    {
      Stage::BID => Bids::BidsPresenter.new(@game, @active_player, visible_stage).props,
      Stage::KING => KingsPresenter.new(@game, @active_player, visible_stage).props,
      Stage::PICK_TALON => PickTalonPresenter.new(@game, @active_player, visible_stage).props,
      Stage::RESOLVE_TALON => ResolveTalonPresenter.new(@game, @active_player, visible_stage).props,
      Stage::ANNOUNCEMENT => Bids::AnnouncementsPresenter.new(@game, @active_player, visible_stage).props,
      Stage::TRICK => TricksPresenter.new(@game, @active_player, visible_stage, visible_trick_index).props,
      Stage::FINISHED => FinishedPresenter.new(@game, @active_player, visible_stage).props,
    }
  end

  def channel_props
    {
      channel: 'PlayersChannel',
      player_id: @active_player.player_id,
      game_id: @game.id
    }
  end

  def paths_props
    {
      update_path: match_player_game_path(@game.match_id, @active_player.player_id, @game.id),
      new_single_player_path: matches_path(match: { human_count: 1 }),
      reset_path: reset_match_player_game_path(@game.match_id, @active_player.player_id, @game.id)
    }
  end

  def forehand
    @players.find { |p| p.forehand? }
  end

  def visible_trick_index
    return 11 if @game.tricks.finished?

    show_penultimate_trick? ? @game.tricks.playable_trick_index - 1 : tricks.playable_trick_index
  end

  def show_penultimate_trick?
    return false if @active_player.played_in_current_trick?
    
    return false if @game.tricks&.current_trick&.finished?

    return false if @game.tricks.playable_trick_index == 0

    return true
  end
end
