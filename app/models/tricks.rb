class Tricks
  include Announcer
  attr_reader :tricks
  delegate :select, :last, :[], :sort_by, to: :tricks
  def initialize(tricks, game)
    @game = game
    @tricks = tricks.order(:id)
    @players = game.players
    @bids = game.bids 
  end

  def first_trick?
    @tricks.length == 0
  end

  def finished?
    @tricks.length == 12 && current_trick&.finished?
  end

  def play_tricks!(card_slug = nil)
    play_card!(card_slug) if card_slug
    until finished? || next_player&.human?
      card = next_player.pick_card
      play_card!(card.slug)
    end
  end

  def play_card!(card_slug)
    player = next_player
    add_trick! if !current_trick || current_trick.finished?
    current_trick.add_card(card_slug, player) if card_slug
    announce(@game, action: 'play_card', player: player.position, card_slug: card_slug, trick_index: current_trick.trick_index)
    @tricks.reload
    add_trick! if current_trick.finished? && !finished?
  end

  def current_trick
    @tricks.last
  end

  def current_trick_finished?
    current_trick&.finished?
  end

  def lead_player
    @tricks[-2]&.won_player || @bids.lead
  end

  def next_player
    return nil if finished?

    # start of first trick - forehand player always leads for now
    return @players.forehand if !current_trick

    # this shouldn't happen with the current setup, but it keeps changing so I'm leaving it in for now
    return current_trick.won_player if current_trick.finished?

    return @tricks[-2].won_player if !current_trick.started?

    # mid trick - find next player
    @players.next_from(current_trick.last_player)
  end

  private

  def add_trick!
    Trick.create(game_id: @game.id, trick_index: next_index)
    @tricks.reload
  end

  def human_player
    @players.find { |p| p.human }
  end

  def next_index
    return current_trick.trick_index + 1 if current_trick

    0
  end
end
