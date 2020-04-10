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

  def next
    match = find_match
    game = match.games.where('id > ?', params[:id]).reject(&:finished?).first
    if game
      redirect_to edit_match_player_game_path(params[:match_id], params[:player_id], game)
    else
      game = match.deal_game
      redirect_to edit_match_player_game_path(params[:match_id], params[:player_id], game)
    end
  end

  def edit
    @match_id = params[:match_id]
    @player_id = params[:player_id].to_i

    @match = MatchPresenter.new(find_match, @player_id)

    @game = GamePresenter.new(find_game, @player_id)
    @players = @game.players
    @player = @players.first
    @action = @game.stage
    @bids = BidsPresenter.new(@game)
    @tricks = TricksPresenter.new(@game)
    message_presenter = MessagePresenter.new(@game)
    @message = message_presenter.message
    @instruction = message_presenter.instruction_msg(@player)

    @show_penultimate_trick = (!@player.played_in_current_trick? || @game.tricks.current_trick.finished?) && @game.tricks.count > 1
    @visible_trick_index = @show_penultimate_trick ? @game.tricks.playable_trick_index - 1 : @game.tricks.playable_trick_index

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

    runner = Runner.new(game, params[:player_id].to_i)
    runner.advance!(**game_params)
  end

  def reset
    game = find_game
    Game.reset!(game.id)

    redirect_to edit_match_player_game_path(params[:match_id], params[:player_id], game)
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
          .permit(:action, :make_bid, :pick_talon, :pick_king, :make_announcement, :resolve_talon => [], :resolve_whole_talon => [], :play_card => [])
          .to_h.symbolize_keys
  end
end
