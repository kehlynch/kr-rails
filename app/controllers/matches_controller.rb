class MatchesController < ApplicationController
  def new
    @match = Match.new
    4.times do |i|
      @match.players.build({'position' => i, human: i == 0})
    end
  end

  def create
    match = Match.new(match_params)
    match.save

    game = match.deal_game

    player = match.players.find_by(human: true)
    redirect_to edit_match_player_game_path(match, player, game)
  end

  private

  def match_params
    params.require(:match).permit(:players_attributes => [:name, :human, :position])
  end
end
