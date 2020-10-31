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

  def last_game
  end

  private

  def match_params
    params.permit(:id)
  end
end
