class GamesController < ApplicationController
  helper_method :game
  before_action :set_view_paths

  def create
    match = Match.find(params[:match_id])
    if match.games.last.finished?
      game = match.deal_game
    else
      game = match.games.last
    end

    redirect_to edit_match_player_game_path(params[:match_id], params[:player_id], game)
  end

  def next
    match = find_match
    game = match.games.where('id > ?', params[:id]).reject(&:finished?).first
    if game
      redirect_to edit_match_player_game_path(params[:match_id], params[:player_id], game)
    else
      game = match.deal_game
      redirect_to edit_match_player_game_path(params[:match_id], params[:player_id], game)
    end
  end

  def edit
    game = GamePresenter.new(find_game, params[:player_id].to_i)

    render locals: game.props
  end

  def update
    game = find_game
    runner = Runner.new(game, params[:player_id].to_i)

    if find_player.id == game.next_player.id
      game = runner.advance!(**game_params)
    end
  end

  def reset
    game = find_game
    Game.reset!(game.id)

    redirect_to edit_match_player_game_path(params[:match_id], params[:player_id], game)
  end


  private

  def find_game
    Game.find(params[:id])
  end

  def find_player
    Player.find(params[:player_id])
  end

  def find_match
    Match.find(params[:match_id])
  end

  def game_params
    params.require(:game)
          .permit(Stage::BID, Stage::KING, Stage::PICK_TALON, Stage::ANNOUNCEMENT, Stage::RESOLVE_TALON => [], Stage::TRICK => [])
          .to_h.symbolize_keys
  end

  def set_view_paths
    prepend_view_path 'app/views/games/'
  end
end
