class GamePresenter
  attr_reader :game, :players

  include Rails.application.routes.url_helpers  

  def initialize(game, active_player_id)
    @game = game
    @active_player = GamePlayer.includes(:cards, :announcements).find_by(player_id: active_player_id, game_id: game.id)
  end

  def props(visible_stage=nil)
    visible_stage ||= Stage.visible_stage_for(game, @active_player)

    {
      paths: paths_props,
      channel: channel_props,
      players: PlayersPresenter.new(@game, @active_player).static_props,
      contract: ContractPresenter.new(@game).props,
      stages: @game.stages_for(@active_player),
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
      update_path: match_game_path(@game.match_id, @game.id),
      new_single_player_path: matches_path(match: { human_count: 1 }),
      reset_path: reset_match_game_path(@game.match_id, @game.id)
    }
  end

  def visible_trick_index
    return 11 unless @game.current_trick.present?

    show_penultimate_trick? ? @game.playable_trick_index - 1 : @game.playable_trick_index
  end

  def show_penultimate_trick?
    return false if @active_player.played_in?(@game.current_trick)
    
    return false if @game&.current_trick&.finished?

    return false if @game.playable_trick_index == 0

    return true
  end
end
