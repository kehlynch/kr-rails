class Api::GamePlayersController < ApplicationController
  def update
    @game_player = GamePlayer.find(params[:id])
    if @game_player.update(game_player_params)
      p 'broadcasting to', @game_player.game
      Broadcaster.broadcast(@game_player.game)
      # render(
      #   json: @game_player,
      #   serializer: GamePlayerSerializer,
      #   root: 'data'
      # )
      render json: :ok
    else
      render json: :error
    end
  end

  private

  def game_player_params
    params.permit(:viewed_bids, :viewed_kings, :viewed_talon, :viewed_announcements, :viewed_trick_index)
  end
end
