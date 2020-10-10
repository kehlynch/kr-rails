class Api::SessionsController < ApplicationController
  def create
    @player = Player.find_or_create_by(name: player_params[:name], human: true)

    set_player_cookie(@player)

    render json: @player
  end

  def retrieve
    render json: @player
  end

  def destroy
    cookies.delete :player_id
    cookies.delete :match_id
    cookies.delete :game_id

    # https://api.rubyonrails.org/classes/ActionController/Redirecting.html
    redirect_to login_path, status: 303
  end

  private

  def player_params
    params.permit(:name, :id)
  end
end
