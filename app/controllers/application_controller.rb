class ApplicationController < ActionController::Base
  before_action :find_player, :find_match, :find_game

  def find_player
    if cookies[:player_id].present?
      @player = Player.find(cookies[:player_id])
    end
  rescue ActiveRecord::RecordNotFound
    cookies.delete :player_id
    # redirect_to login_path
  end

  def find_game
    if cookies[:game_id].present?
      @game = Game.find(cookies[:game_id])
    end
  rescue ActiveRecord::RecordNotFound
    cookies.delete :game_id
    redirect_to home_path
  end

  def find_match
    if cookies[:match_id].present?
      @match = Match.find(cookies[:match_id])
    end
  rescue ActiveRecord::RecordNotFound
    cookies.delete :match_id
    redirect_to home_path
  end

  private

  def set_player_cookie(player)
    cookies[:player_id] = player.id
  end

  def set_game_cookie(game)
    cookies[:game_id] = game.id
  end

  def set_match_cookie(match)
    cookies[:match_id] = match.id
  end
end
