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
    runner = Runner.resume(game.data)
    if game_params['next_trick']
      runner.next_trick
    elsif game_params['card']
      runner.play(game_params['card'])
    elsif game_params['contract']
      runner.contract = game_params['contract']
    end
    params = { data: runner.serialize }

    game.update(params)
    redirect_to edit_game_path(game)
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
    params.require(:game).permit(:card, :next_trick)
  end
end
