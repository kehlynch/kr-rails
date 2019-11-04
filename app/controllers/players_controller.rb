class PlayersController < ApplicationController
  def show
    # ActionCable.server.broadcast("MessageChannel_#{params[:match_id]}", sent_by: "Kat", body: "hello")
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
    position = match.players.max_by(&:position).position + 1
    player = Player.create(player_params.merge({match_id: match_id, human: true, position: position}))
    match.players.reload
    if player.match.players.length == 4
      game = match.games.last || match.deal_game

      path = edit_match_player_game_path(match, player, game)
    else
      path = match_player_path(match, player)
    end

    ActionCable.server.broadcast("MessageChannel", sent_by: "Kat", body: "hello")
    redirect_to path
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end
end
