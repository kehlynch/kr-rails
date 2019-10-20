# frozen_string_literal: true

require 'game'

class GamesController < ApplicationController
  helper_method :game

  def index
    redirect_to(action: :new)
  end

  def create
    game = Game.deal_game

    redirect_to edit_game_path(game)
  end

  def show
    redirect_to(action: :edit, game: find_game)
  end

  def edit
    game_id = params[:id]
    @game = find_game
    @stage = StagePresenter.new(game_id)
    @players = PlayersPresenter.new(game_id)
    @bids = BidsPresenter.new(game_id)
    @tricks = TricksPresenter.new(game_id)
  end

  def update
    game = find_game
    case game_params[:action]
      when 'make_bid'
        game.make_bid!(game_params[:make_bid])
      when 'pick_king'
        game.pick_king!(game_params[:pick_king])
      when 'pick_talon'
        game.pick_talon!(game_params[:pick_talon].to_i)
      when 'resolve_talon'
        game.resolve_talon!(game_params[:resolve_talon])
      when 'play_card'
        game.play_current_trick!(game_params[:play_card][0])
      when 'next_trick'
        game.play_next_trick!
    end
    redirect_to edit_game_path(game)
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    redirect_to games_path
  end

  private

  def resume_runner
    Runner.resume(find_game.data)
  end

  def find_game
    Game.find(params[:id])
  end

  def game_params
    params.require(:game)
          .permit(:action, :make_bid, :pick_king, :pick_talon, :resolve_talon => [], :play_card => [])
          .to_h.symbolize_keys
  end
end
