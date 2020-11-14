class Api::MatchesController < ApplicationController
  def list_open
    render(
      json: Match.open_matches_for(@player),
      only: [:id],
      methods: [:hand_description, :days_old],
      include: {
        players: {
          only: [:id, :name, :human]
        }
      },
      player: @player
    )
  end

  def goto_last_game
    match = Match.find(match_params[:id])
    set_match_cookies(match)
    game = match.games.reject(&:finished?).last || match.deal_game
    set_game_cookie(game)
    render(
      json: @game,
      include: {
        players: {
          only: [:id, :name, :human]
        }
      }
    )
  end

  private

  def match_params
    params.permit(:id)
  end
end
