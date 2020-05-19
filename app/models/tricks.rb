class Tricks
  attr_reader :tricks

  delegate(
    :[],
    :count,
    :each,
    :each_with_index,
    :find,
    :first,
    :last,
    :length,
    :select,
    :sort_by,
    :empty?,
    to: :tricks
  )

  def initialize(tricks, game)
    @game = game
    @tricks = tricks.sort_by(&:id)
    @players = game.game_players
    @bids = game.bids
  end

  def finished?
    # TODO finish early if negative bid lost
    tricks.find { |t| t.trick_index == 11 }.finished?
  end

  def started?
    !empty?
  end

  def play_card!(card = nil)
    player = next_player

    return nil if finished? || (player&.human? && !card)

    card ||= player.pick_card
    return nil unless card && from_next_player?(card)

    add_card!(card)
  end

  def current_trick
    last_played_trick = @tricks
      .select { |t| t.cards != [] }
      .max_by(&:trick_index)

    return @tricks.find { |t| t.trick_index == 0 } unless last_played_trick
    
    return last_played_trick unless last_played_trick.finished?

    return @tricks.find { |t| t.trick_index == last_played_trick.trick_index + 1 }
  end

  def current_trick_finished?
    current_trick&.finished?
  end

  def playable_trick_index
    current_trick&.trick_index
  end

  def lead_player
    @tricks[-2]&.won_player || @bids.lead
  end

  def next_player
    return nil if finished?

    return current_trick.won_player if current_trick.finished?

    # mid trick - find next player
    current_trick.next_player
  end

  private

  def add_card!(card)
    current_trick.add_card(card)
  end

  def human_player
    @players.find { |p| p.human }
  end

  def next_index
    return current_trick.trick_index + 1 if current_trick

    0
  end

  def from_next_player?(card)
    card && card.game_player.id == next_player.id
  end
end
