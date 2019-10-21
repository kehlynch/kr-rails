class GamesController < ApplicationController
  helper_method :game

  def create
    game = Match.find(params[:match_id]).deal_game

    redirect_to edit_match_game_path(params[:match_id], game)
  end

  def edit
    @match_id = params[:match_id]
    game_id = params[:id]
    @game = find_game
    @stage = StagePresenter.new(game_id)
    @players = PlayersPresenter.new(game_id)
    @bids = BidsPresenter.new(game_id)
    @tricks = TricksPresenter.new(game_id)
    @match_games = Game.where(match_id: @match_id)
  end

  def update
    game = find_game
    case game_params[:action]
      when 'make_bid'
        game.make_bid!(game_params[:make_bid])
      when 'pick_king'
        game.pick_king!(game_params[:pick_king])
      when 'pick_talon'
        game.pick_talon!(game_params[:pick_talon].to_i)
      when 'pick_whole_talon'
        game.pick_whole_talon!
      when 'resolve_talon'
        game.resolve_talon!(game_params[:resolve_talon])
      when 'resolve_whole_talon'
        game.resolve_talon!(game_params[:resolve_whole_talon])
      when 'play_card'
        game.play_current_trick!(game_params[:play_card][0])
      when 'next_trick'
        game.play_next_trick!
    end
    redirect_to edit_match_game_path(params[:match_id], game)
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    redirect_to games_path
  end

  private

  def find_game
    Game.find(params[:id])
  end

  def game_params
    params.require(:game)
          .permit(:action, :make_bid, :pick_king, :pick_talon, :resolve_talon => [], :resolve_whole_talon => [], :play_card => [])
          .to_h.symbolize_keys
  end
end
