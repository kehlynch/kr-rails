class PlayersController < ApplicationController
  before_action :lookup_match

  def show
    @player = Player.find(params[:id])
    @missing_players = 4 - @match.players.length
    if @missing_players == 0
      game = @match.games.last || @match.deal_game
      MatchesChannel.broadcast_to(match, ready: true, game_id: game.id); 
      redirect_to edit_match_player_game_path(@match, params[:id], game)
    end
  end

  def new
    @player = Player.new(match_id: params[:match_id])
  end

  def create
    match_id = params[:match_id]
    player_count = @match.players.length

    if player_count > 3
      flash[:error] = 'Sorry, 4 players are already in this game'
      redirect_to matches_path
    else
      position = (Player::POSITIONS - @match.players.map(&:position)).sample

      player = Player.create(player_params.merge({match_id: match_id, human: true, position: position}))
      @match.players.reload
      if @match.players.length == 4
        game = @match.games.last || @match.deal_game

        MatchesChannel.broadcast_to(@match, ready: true, game_id: game.id); 
        path = edit_match_player_game_path(@match, player, game)
      else
        path = match_player_path(@match, player)
      end

      ActionCable.server.broadcast("MessageChannel", sent_by: "Kat", body: "hello")
      redirect_to path
    end
  end

  private

  def lookup_match
    @match = Match.find(params[:match_id])
  end

  def player_params
    params.require(:player).permit(:name)
  end
end
