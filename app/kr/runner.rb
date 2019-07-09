# frozen_string_literal: true

class Runner
  def self.start(nohuman = false)
    deck = Deck.new
    opts = {
      talon: deck.talon,
      bidding: Bidding.new,
      tricks: Tricks.new,
      players: Player.players(deck.hands, nohuman),
    }
    Runner.new(opts)
  end

  def self.resume(params)
    opts = {
      talon: Talon.deserialize(params['talon']),
      bidding: Bidding.deserialize(params['bidding']),
      tricks: Tricks.deserialize(params['tricks']),
      players: params['players'].map { |player| Player.deserialize(player) },
    }
    Runner.new(opts)
  end

  attr_reader :talon, :tricks, :players, :bidding, :king

  def initialize(**opts)
    @talon = opts[:talon]
    @bidding = opts[:bidding]
    @tricks = opts[:tricks]
    @players = opts[:players]
  end

  def serialize
    {
      'talon' => @talon.serialize,
      'tricks' => @tricks.serialize,
      'players' => @players.map(&:serialize),
      'bidding' => @bidding.serialize,
    }
  end

  def play(**args)
    # todo prob should deal with array input in controller or view
    play_current_trick(args[:play_card][0].to_sym) if args[:play_card]
    play_next_trick if args[:next_trick]
    @bidding.contract = args[:pick_contract].to_sym if args[:pick_contract]
    @bidding.king = args[:pick_king].to_sym if args[:pick_king]
    pick_talon(args[:pick_talon].to_i) if args[:pick_talon]
    resolve_talon(args[:resolve_talon].map(&:to_sym)) if args[:resolve_talon]
    return unless stage == :finished

    calculate_scores
  end

  def pick_talon(talon_half_index)
    cards = @talon.remove_half(talon_half_index)
    # assume player 0 for now
    @players[0].hand.add(cards)
    @bidding.talon_picked = true
  end

  def resolve_talon(card_slugs)
    # assume player 0 for now
    @players[0].discard(card_slugs)
    @bidding.talon_resolved = true
  end

  def stage
    return :finished if @tricks.finished?

    return :play_card if @bidding.stage == :finished

    return @bidding.stage
  end

  def current_trick
    @tricks[-1]
  end

  def current_trick_finished?
    current_trick&.finished
  end

  def lead_player_id
    last_finished_trick&.winning_player_id || 0
  end

  def last_finished_trick
    return current_trick if current_trick&.finished

    @tricks[-2]
  end

  def winners 
    [@players.max_by(&:points).id]
  end

  private

  def play_current_trick(card_slug = nil)
    play_card(card_slug, next_player) if card_slug
    current_player = next_player
    until current_player.human || current_trick&.finished || stage == :finished
      card = current_player.pick_card(@tricks)
      play_card(card.slug, current_player)
      current_player = next_player
    end
    @players.each { |p| p.tag_legal_cards(current_trick) }
  end

  def play_next_trick
    @tricks.add_trick
    play_current_trick
  end

  def play_card(card_slug, player)
    maybe_start_trick
    card = player.remove_from_hand(card_slug)
    current_trick.add(card)
  end

  def maybe_start_trick
    @tricks.add_trick if !@tricks[-1] || @tricks[-1].finished
  end

  def calculate_scores
    @players.each do |p|
      won_cards = @tricks.won_cards(p.id)
      p.points = Card.calculate_points(won_cards)
    end
  end

  def previous_trick
    @tricks[-2]
  end

  def next_player
    player_id =
      current_trick&.next_player_id || previous_trick&.won_player_id || 0
    @players[player_id]
  end
end
