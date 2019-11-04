class MatchesController < ApplicationController
  def index
    @matches = Match.select { |m| m.players.length < 4 }
  end


  def new
    @match = Match.new
    @human_count_select = human_count_select
  end

  def create
    match = Match.create
    human_player = Player.create({'position' => 0, name: match_params[:human_name], match: match, human: true})
    bot_count = 4 - match_params[:human_count].to_i
    bot_count.times do |i|
      Player.create({'position' => i + 1, match: match})
    end

    if match_params[:human_count].to_i == 1
      match.players.reload
      game = match.deal_game

      redirect_to edit_match_player_game_path(match, human_player, game)
    else
      redirect_to match_player_path(match, human_player)
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
