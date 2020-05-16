class PlayersPresenter
  def initialize(game, active_player)
    @game = game
    @active_player = active_player
  end

  def static_props
    @game.players.map do |player|
      PlayerPresenter.new(player, @game, @active_player).props
    end
  end

  def props_for_bids
    @game.players.map do |player|
      PlayerPresenter.new(player, @game, @active_player).props_for_bids
    end
  end

  def props_for_announcements
    @game.players.map do |player|
      PlayerPresenter.new(player, @game, @active_player).props_for_announcements
    end
  end
end
