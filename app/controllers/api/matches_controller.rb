class Api::MatchesController < ApplicationController
  def create
    match = Match.create
    match.match_players.create(match: match, player: @player)
    bot_count = 4 - match_params[:human_count].to_i

    require 'pry'; binding.pry()

    bot_count.times do
      bot = Player.create(human: false)
      match.match_players.create(match: match, player: bot)
    end

    if match.match_players.count == 4
      game = match.deal_game

      set_game_cookie(game)
    end
    set_match_cookie(match)

    render(
      json: @match,
      include: {
        players: {
          only: [:id, :name, :human]
        }
      }
    )
  end

  def current
    render(
      json: @match,
      include: {
        players: {
          only: [:id, :name, :human]
        }
      }
    )
  end

  def list_open
    render(
      json: Match.open_matches_for(@player),
      only: [:id],
      methods: [:hand_description, :days_old],
      include: {
        players: {
          only: [:id, :name, :human]
        }
      },
      player: @player
    )
  end

  def set
    match = Match.find(match_params[:id])
    set_match_cookie(match)
    render(
      json: @game,
      include: {
        players: {
          only: [:id, :name, :human]
        }
      }
    )
  end

  def goto_last_game
    match = Match.find(match_params[:id])
    set_match_cookie(match)
    game = match.games.reject(&:finished?).last || match.deal_game
    set_game_cookie(game)
    render(
      json: @game,
      include: {
        players: {
          only: [:id, :name, :human]
        }
      }
    )
  end

  private

  def match_params
    params.permit(:id, :human_count)
  end
end
