class Tricking
  def initialize(game_id)
    @game_id = game_id
    @tricks = Trick.where(game_id: game_id).order(:trick_index)
    @players = Player.where(game_id: game_id)
  end

  def finished?
    @tricks.length == 12 && current_trick&.finished?
  end

  def play_next_trick!
    add_trick!
    play_current_trick!
  end

  def play_current_trick!(card_slug = nil)
    play_card!(card_slug) if card_slug
    until next_player.human || current_trick&.finished? || finished?
      card = next_player.pick_card
      play_card!(card.slug)
    end
  end

  def play_card!(card_slug)
    add_trick! if !current_trick
    current_trick.add_card(card_slug, next_player) if card_slug
    @tricks.reload
  end

  def current_trick
    @tricks.last
  end

  private

  def add_trick!
    Trick.create(game_id: @game_id, trick_index: next_index)
    @tricks.reload
  end

  def next_player
    # start of first trick - human player always leads for now
    return human_player if !current_trick

    return @tricks[-2]&.won_player if !current_trick.started?

    # mid trick - find next player
    Player.next_from(current_trick.last_player)
  end

  def human_player
    @players.find { |p| p.human }
  end

  def next_index
    return current_trick.trick_index + 1 if current_trick

    0
  end
end
