class GamesController < ApplicationController
  include Announcer
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
    @match = MatchPresenter.new(Match.find(@match_id))

    @game = find_game
    @action = @game.stage
    @bids = BidsPresenter.new(@game)
    @announcements = AnnouncementsPresenter.new(@game)
    @player_id = params[:player_id].to_i
    @players = PlayersPresenter.new(@game, @player_id)
    @tricks = TricksPresenter.new(@game)
    @player = @players.first
    @message = MessagePresenter.new(@game, @action, @player).message
    @player.active = true
    @my_move = @game.next_player&.id == @player.id
    @waiting = !@my_move
  end

  def update
    game = find_game
    # path = edit_match_player_game_path(params[:match_id], params[:player_id], game)
    player = Player.find(params[:player_id])
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
        game.play_tricks!(card_slug)
      when 'next_trick'
        raise 'not doing next_trick anymore'
      when 'finished'
        if game.finished?
          new_game = game.match.deal_game
          redirect_to edit_match_player_game_path(params[:match_id], params[:player_id], new_game)
        end
    end

    player = PlayersPresenter.new(game, params[:player_id].to_i).first
    message = MessagePresenter.new(game, game.stage, player).message
    announce(game, action: :info, message: message, stage: game.stage, next_player: game.next_player&.id, current_trick_index: game.current_trick&.trick_index)

    announce(game, action: :info, message: message, stage: game.stage, next_player: game.next_player&.id, current_trick_index: game.current_trick&.trick_index)

    broadcast_player_info(game)

    if game.finished?
      match = Match.find(params[:match_id])
      broadcast_scores(game, match, params[:player_id].to_i)
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    redirect_to games_path
  end

  private

  def broadcast_scores(game, match, player_id)
    scores = PlayersPresenter.new(game, player_id).map do |player|
      {
        name: player.name,
        won_tricks_count: player.won_tricks_count,
        points: player.points,
        team_points: player.team_points,
        game_points: player.game_points,
        winner: player.winner?
      }
    end

    game_summaries = MatchPresenter.new(match).games.map(&:summary)

    announce(game, action: :score, scores: scores, game_summaries: game_summaries)
  end

  def broadcast_player_info(game)
    player = Player.find(params[:player_id])
    my_move = game.next_player&.id == player.id
    announce_player(player, my_move: my_move)

    if game.partner_known_by?(player.id)
      announce_player(player, partner: game.partner.position)
    end

    if my_move
      case game.stage
        when 'make_bid'
          announce_player(player, valid_bids: game.bids.valid_bids)
        when 'make_announcement'
          announce_player(player, valid_announcements: game.announcements.valid_announcements)
        # when 'pick_king'
        # when 'pick_talon'
        # when 'pick_whole_talon'
        # when 'resolve_talon'
        # when 'resolve_whole_talon'
        # when 'next_trick'
        # when 'finished'
      end
    end

    if ['play_card', 'resolve_talon', 'make_announcement', 'finished'].include?(game.stage)
      game_player = GamePlayer.new(player, game)
      hand = HandPresenter.new(game_player.hand).sorted.map { |c| {slug: c.slug, legal: c.legal?} }
      announce_player(player, hand: hand)
    end
  end

  def find_game
    Game.find(params[:id])
  end

  def game_params
    params.require(:game)
          .permit(:action, :make_bid, :pick_talon, :pick_king, :make_announcement => [], :resolve_talon => [], :resolve_whole_talon => [], :play_card => [])
          .to_h.symbolize_keys
  end
end
