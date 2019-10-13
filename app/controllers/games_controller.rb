# frozen_string_literal: true

require 'game'

class GamesController < ApplicationController
  helper_method :game

  def index
    @runner = Game.all
  end

  # def show
  #   @runner = Runner.resume(Game.find(params[:id]))
  # end

  def new
    # @runner = Runner.start
  end

  def create
    game = Game.create

    redirect_to edit_game_path(game)
  end

  def edit
    @game = find_game

    # @runner = Runner.resume(@game.data)
  end

  def update
    game = find_game
    case game_params[:action]
      when 'pick_contract'
        game.update(contract: game_params[:pick_contract])
      when 'pick_king'
        game.update(king: game_params[:pick_king])
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
          .permit(:action, :pick_contract, :pick_king, :pick_talon, :resolve_talon => [], :play_card => [])
          .to_h.symbolize_keys
  end
end
