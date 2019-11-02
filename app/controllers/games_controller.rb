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
    @game = find_game
    @action = @game.stage
    @bids = BidsPresenter.new(@game)
    @announcements = AnnouncementsPresenter.new(@game)
    @match_games = Match.find(@match_id).games
    @match_players = Player.where(match_id: @match_id)
    @player_id = params[:player_id].to_i
    @players = PlayersPresenter.new(@game, @player_id)
    @tricks = TricksPresenter.new(@game, @players)
    @player = @players.first
    @message = MessagePresenter.new(@game, @action, @player).message
    @player.active = true
  end

  def update
    game = find_game
    path = edit_match_player_game_path(params[:match_id], params[:player_id], game)
    case game_params[:action]
      when 'make_bid'
        game.make_bid!(game_params[:make_bid])
      when 'make_announcement'
        game.make_announcements!(game_params[:make_announcement])
      when 'pick_king'
        game.pick_king!(game_params[:pick_king])
      when 'pick_talon'
        game.pick_talon!(game_params[:pick_talon].to_i)
      when 'pick_whole_talon'
        game.pick_whole_talon!
      when 'resolve_talon'
        game.resolve_talon!(game_params[:resolve_talon])
      when 'resolve_whole_talon'
        game.resolve_talon!(game_params[:resolve_whole_talon])
      when 'play_card'
        card_slug = game_params[:play_card][0] if game_params[:play_card] 
        game.play_current_trick!(card_slug)
      when 'next_trick'
        game.play_next_trick!
      when 'finished'
        if game.finished?
          new_game = game.match.deal_game
          path = edit_match_player_game_path(params[:match_id], params[:player_id], new_game)
        end
    end

    redirect_to path
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

  def game_params
    params.require(:game)
          .permit(:action, :make_bid, :pick_talon, :pick_king, :make_announcement => [], :resolve_talon => [], :resolve_whole_talon => [], :play_card => [])
          .to_h.symbolize_keys
  end
end
