class MatchesController < ApplicationController

  def index
    @matches = Match.order(created_at: :desc).limit(10)
  end

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
    positions = Player::POSITIONS
    human_position = positions.delete(positions.sample)
    human_player = Player.create({'position' => human_position, name: match_params[:human_name], match: match, human: true})
    bot_count = 4 - match_params[:human_count].to_i

    positions.sample(bot_count).each do |position|
      Player.create({'position' => position, match: match})
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
