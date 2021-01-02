class Api::GamesController < ApplicationController
  def current
    if !@game
      render(json: :not_found)
    else
      render(
        json: @game,
        serializer: GameSerializer,
        root: 'data'
      )
    end
  end

  def update_current
    runner = Runner.new(@game, @player.id)

    if @player.id == @game.next_player.player_id
      @game = runner.advance!(**game_params)
    end

    render json: nil
  end

  def test
    ActionCable.server.broadcast('test', {message: 'a message I am sending to the channel'})

    render json: nil
  end

  private

  def game_params
    params.permit(
      Stage::BID,
      Stage::KING,
      Stage::PICK_TALON,
      Stage::ANNOUNCEMENT,
      Stage::TRICK,
      Stage::RESOLVE_TALON => [],
    ).to_h.symbolize_keys
  end
end
