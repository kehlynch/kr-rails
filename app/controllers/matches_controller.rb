class MatchesController < ApplicationController
  def create
    match = Match.create
    4.times.collect do |i|
      Player.create(match: match, human: i == 0, position: i)
    end

    game = match.deal_game
    
    redirect_to edit_match_game_path(match, game)
  end
end
