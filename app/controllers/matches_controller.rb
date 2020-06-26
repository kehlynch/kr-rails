class MatchesController < ApplicationController
  def new
    @match = Match.new
    @human_count_select = human_count_select
  end

  def destroy
    Match.find(params[:id]).destroy!
    redirect_to matches_path
  end

  def create
    match = Match.create
    match.match_players.create(match: match, player: @player)
    bot_count = 4 - match_params[:human_count].to_i

    bot_count.times do
      bot = Player.create(human: false)
      match.match_players.create(match: match, player: bot)
    end

    if match.match_players.count == 4
      match.deal_game

      set_match_cookies(match)

      redirect_to play_path
    else
      redirect_to home_path
    end
  end

  def scores
    if @match.present?
      render locals: MatchPointsPresenter.new(@match).props
    else
      redirect_to home_path
    end
  end

  private

  def human_count_select
    [
      ["single player", 1],
      ["1 friend, 2 bots", 2],
      ["2 friends, 1 bot", 3],
      ["3 friends", 4]
    ]
  end

  def match_params
    params.require(:match).permit(:human_name, :human_count)
  end
end
