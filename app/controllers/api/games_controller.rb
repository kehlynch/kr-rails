class Api::GamesController < ApplicationController
  def current
    render(
      json: @game,
      serializer: GameSerializer,
      root: 'data'
    )
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
    params.permit(Stage::BID, Stage::KING, Stage::PICK_TALON, Stage::ANNOUNCEMENT, Stage::RESOLVE_TALON => [], Stage::TRICK => [])
          .to_h.symbolize_keys
  end
end
