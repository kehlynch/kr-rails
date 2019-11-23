class GamesController < ApplicationController
  helper_method :game

  def create
    match = Match.find(params[:match_id])
    if match.games.last.finished?
      game = match.deal_game
    else
      game = match.games.last
    end

    redirect_to edit_match_player_game_path(params[:match_id], params[:player_id], game)
  end

  def edit
    @match_id = params[:match_id]
    @player_id = params[:player_id].to_i

    @match = MatchPresenter.new(find_match, @player_id)

    @game = GamePresenter.new(find_game, @player_id)
    @players = @game.players
    @action = @game.stage
    @bids = BidsPresenter.new(@game)
    @tricks = TricksPresenter.new(@game)
    @player = @players.first
    message_presenter = MessagePresenter.new(@game, @player)
    @message = message_presenter.message
    @instruction = message_presenter.instruction_msg

    @player.active = true
    @my_move = @game.next_player&.id == @player.id
    @waiting = !@my_move
  end

  def update
    game = find_game

    if game_params[:action] == 'finished' && game.finished?
      new_game =  find_match.deal_game
      redirect_to edit_match_player_game_path(params[:match_id], params[:player_id], new_game)
    end

    runner = Runner.new(game, find_player)
    runner.advance!(**game_params)
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    redirect_to games_path
  end

  private

  def find_game
    Game.find(params[:id])
  end

  def find_player
    Player.find(params[:player_id])
  end

  def find_match
    Match.find(params[:match_id])
  end

  def game_params
    params.require(:game)
          .permit(:action, :make_bid, :pick_talon, :pick_king, :make_announcement => [], :resolve_talon => [], :resolve_whole_talon => [], :play_card => [])
          .to_h.symbolize_keys
  end
end
