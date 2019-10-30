class GamesController < ApplicationController
  helper_method :game

  def create
    game = Match.find(params[:match_id]).deal_game

    redirect_to edit_match_game_path(params[:match_id], game)
  end

  def edit
    @match_id = params[:match_id]
    @game = find_game
    @stage = StagePresenter.new(@game)
    @bids = BidsPresenter.new(@game)
    @tricks = TricksPresenter.new(@game)
    @announcements = AnnouncementsPresenter.new(@game)
    @match_games = Game.where(match_id: @match_id)
    @match_players = Player.where(match_id: @match_id)
    @players = PlayersPresenter.new(@game)
  end

  def update
    game = find_game
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
    end
    redirect_to edit_match_game_path(params[:match_id], game)
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
