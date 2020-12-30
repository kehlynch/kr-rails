class Api::MatchesController < ApplicationController
  def create
    match = Match.create
    match.match_players.create(match: match, player: @player)
    bot_count = 4 - match_params[:human_count].to_i

    bot_count.times do
      bot = Player.create(human: false)
      match.match_players.create(match: match, player: bot)
    end

    if match.match_players.count == 4
      game = match.deal_game

      set_game_cookie(game)
    end
    set_match_cookie(match)

    render_match(match)
  end

  def current
    render_match
  end

  def list_open

    if !@player
      render(
        json: [],
        each_serializer: MatchSerializer,
        root: 'data'
      )
    else
      render(
        json: Match.open_matches_for(@player),
        each_serializer: MatchSerializer,
        root: 'data'
        # only: [:id],
        # methods: [:hand_description, :days_old],
        # include: {
        #   players: {
        #     only: [:id, :name, :human]
        #   }
        # },
        # player: @player
      )
    end
  end

  def set
    match = Match.find(match_params[:id])
    set_match_cookie(match)
    render(
      json: @game,
      root: 'data',
      serializer: GameSerializer
    )
  end

  def goto_last_game
    match = Match.find(match_params[:id])
    set_match_cookie(match)
    game = match.games.reject(&:finished?).last || match.deal_game
    set_game_cookie(game)
    render(
      json: @game,
      serializer: GameSerializer,
      root: 'data'
      # include: {
      #   players: {
      #     only: [:id, :name, :human]
      #   }
      # }
    )
  end

  private

  def match_params
    params.permit(:id, :human_count)
  end

  def render_match(match = @match)
    render(
      json: match,
      serializer: MatchSerializer,
      root: 'data'
    )
  end
end
