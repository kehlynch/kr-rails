class SessionsController < ApplicationController
  def new
    @player ||= Player.new
  end

  def create
    @player = Player.find_or_create_by(name: player_params[:name], human: true)

    cookies[:player_id] = @player.id
    redirect_to home_path
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
    params.require(:player).permit(:name)
  end
end
