class Tricks
  attr_reader :tricks
  delegate :select, :first, :last, :[], :sort_by, :each, to: :tricks
  def initialize(tricks, game)
    @game = game
    @tricks = tricks.sort_by(&:id)
    @players = game.players
    @bids = game.bids
  end

  def finished?
    @tricks.length == 12 && current_trick&.finished?
  end

  def play_card!(card = nil)
    player = next_player
    return nil unless from_next_player?(card)
    return nil if finished? || (player&.human? && !card)

    card ||= player.pick_card
    add_card!(card)
  end

  def current_trick
    @tricks.last
  end

  def current_trick_finished?
    current_trick&.finished?
  end

  def playable_trick_index
    return 0 unless current_trick

    return @tricks.length - 1 unless current_trick.finished?

    return @tricks.length
  end

  def lead_player
    @tricks[-2]&.won_player || @bids.lead
  end

  def next_player
    return nil if finished?

    # start of first trick - forehand player always leads for now
    return @bids.lead unless current_trick

    return current_trick.won_player if current_trick.finished?

    # return @tricks[-2].won_player if !current_trick.started?

    # mid trick - find next player
    @players.next_from(current_trick.last_player)
  end

  private

  def add_card!(card)
    add_trick! if !current_trick || current_trick.finished?
    current_trick.add_card(card)
    # add_trick! if current_trick.finished? && !finished?
  end

  def add_trick!
    @tricks << Trick.create(game_id: @game.id, trick_index: next_index)
  end

  def human_player
    @players.find { |p| p.human }
  end

  def next_index
    return current_trick.trick_index + 1 if current_trick

    0
  end

  def from_next_player?(card)
    card && card.player.id == next_player.id
  end
end
