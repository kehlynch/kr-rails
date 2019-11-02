class PlayersController < ApplicationController
  def show
    @match = Match.find(params[:match_id])
    @missing_players = 4 - @match.players.length
    if @missing_players == 0
      game = @match.games.last || @match.deal_game
      redirect_to edit_match_player_game_path(@match, params[:id], game)
    end
  end

  def new
    @match = Match.find(params[:match_id])
    @player = Player.new(match_id: params[:match_id])
  end

  def create
    match_id = params[:match_id]
    match = Match.find(match_id)
    player = Player.create(player_params.merge({match_id: match_id}))
    if player.match.players.length == 4
      game = match.deal_game

      redirect_to edit_match_player_game_path(match, player, game)
    else
      redirect_to match_player_path(match, player)
    end
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end
end
