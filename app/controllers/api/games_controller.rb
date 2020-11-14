class Api::GamesController < ApplicationController
  def current
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
