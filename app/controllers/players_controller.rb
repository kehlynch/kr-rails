class PlayersController < ApplicationController
  def join_match
    match = Match.find(params[:match_id])
    MatchPlayer.create(match: match, player: @player)

    if match.match_players.count == 4
      match.deal_game

      redirect_to play_path
    else
      redirect_to matches_path
    end
  end
  
  def play_match
    match = Match.find(params[:match_id])
    set_match_cookies(match)

    redirect_to play_path
  end

  def show
    if @player.present?
      @my_matches = @player.matches
      @open_matches = Match.open_matches_for(@player)
    else
      redirect_to login_path unless @player.present?
    end
  end

  def index
    @players = Player.where(human: true)
  end
end
