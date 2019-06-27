# frozen_string_literal: true

class Runner
  def self.start(nohuman = false)
    deck = Deck.new
    opts = {
      talon: deck.talon,
      tricks: Tricks.new,
      players: Player.players(deck.hands, nohuman)
    }
    Runner.new(opts)
  end

  def self.resume(params)
    opts = {
      talon: Talon.deserialize(params['talon']),
      tricks: Tricks.deserialize(params['tricks']),
      players: params['players'].map { |player| Player.deserialize(player) },
      contract: params['contract']&.to_sym
    }
    Runner.new(opts)
  end

  attr_reader :talon, :tricks, :players, :contract

  def initialize(**opts)
    @talon = opts[:talon]
    @tricks = opts[:tricks]
    @players = opts[:players]
    @contract = opts[:contract]
  end

  def serialize
    {
      'talon' => @talon.serialize,
      'tricks' => @tricks.serialize,
      'players' => @players.map(&:serialize),
      'contract' => @contract
    }
  end

  def play(**args)
    play_current_trick(args[:play_card]) if args[:play_card]
    play if args[:play] # for testing with no human
    play_next_trick if args[:next_trick]
    @contract = args[:pick_contract].to_sym if args[:pick_contract]
    return unless game_finished?

    calculate_scores
  end

  def game_finished?
    @tricks.finished?
  end

  def pick_rufer?
    !@tricks.started? || !@contract
  end

  def pick_talon?
    @contract == :rufer
  end

  def pick_card?
    !@tricks.empty?
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

  private

  def play_current_trick(card_slug = nil)
    play_card(card_slug, next_player) if card_slug
    current_player = next_player
    until current_player.human || current_trick&.finished || game_finished?
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
