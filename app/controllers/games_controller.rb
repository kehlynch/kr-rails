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
    game = Game.create(data: Runner.start.serialize)

    redirect_to edit_game_path(game)
  end

  def edit
    @game = find_game

    @runner = Runner.resume(@game.data)
  end

  def update
    game = find_game
    @runner = Runner.resume(game.data)
    @runner.play(game_params)
    params = { data: @runner.serialize }
    game.update(params)
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
          .permit(:play_card, :next_trick, :pick_contract, :pick_king)
          .to_h.symbolize_keys
  end
end
