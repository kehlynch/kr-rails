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

    set_game_cookie(game)

    redirect_to play_path
  end

  def next
    game = @match.games.where('id > ?', params[:id]).reject(&:finished?).first
    game ||= @match.deal_game

    set_game_cookie(game)

    redirect_to play_path
  end

  def play
    game = GamePresenter.new(@game, @player.id)

    render locals: game.props
  end

  def update
    runner = Runner.new(@game, @player.id)

    if @player.id == @game.next_player.player_id
      @game = runner.advance!(**game_params)
    end
  end

  def reset
    @game.reset!

    redirect_to play_path
  end


  private

  def game_params
    params.require(:game)
          .permit(Stage::BID, Stage::KING, Stage::PICK_TALON, Stage::ANNOUNCEMENT, Stage::RESOLVE_TALON => [], Stage::TRICK => [])
          .to_h.symbolize_keys
  end

  def set_view_paths
    prepend_view_path 'app/views/games/'
  end
end
