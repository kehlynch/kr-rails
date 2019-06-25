# frozen_string_literal: true

class Runner
  def self.start
    deck = Deck.new
    tricks = []
    players = Player.players(deck.hands)
    Runner.new(deck.talon, tricks, players)
  end

  def self.resume(params)
    # hands = params['hands'].map { |hand| Hand.deserialize(hand) }
    talon = Talon.deserialize(params['talon'])
    tricks = params['tricks'].map { |trick| Trick.deserialize(trick) }
    players = params['players'].map { |player| Player.deserialize(player) }
    Runner.new(talon, tricks, players)
  end

  attr_reader :talon, :tricks, :players

  def initialize(talon = nil, tricks = nil, players = nil)
    @talon = talon
    @tricks = tricks
    @players = players
  end

  def serialize
    {
      'talon' => @talon.serialize,
      'tricks' => @tricks.map(&:serialize),
      'players' => @players.map(&:serialize)
    }
  end

  def next_trick
    @tricks.append(Trick.new)
    play
  end

  def play(card_slug = nil)
    play_card(card_slug, next_player) if card_slug
    advance_current_trick
    @players.each { |p| p.tag_legal_cards(current_trick) }

    return unless game_finished?

    calculate_scores
  end

  def game_finished?
    @tricks.length == 12 && @tricks[-1].finished
  end

  def pick_rufer?
    @tricks.empty?
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

  def advance_current_trick
    current_player = next_player
    until current_player.human || current_trick&.finished || game_finished?
      card = current_player.pick_card(@tricks)
      play_card(card.slug, current_player)
      current_player = next_player
    end
  end

  def play_card(card_slug, player)
    maybe_start_trick
    card = player.remove_from_hand(card_slug)
    current_trick.add(card)
  end

  def maybe_start_trick
    @tricks.append(Trick.new) if !@tricks[-1] || @tricks[-1].finished
  end

  def calculate_scores
    @players.each do |p|
      won_cards = @tricks
                  .select { |t| t.winning_player_id == p.id }
                  .map(&:cards)
                  .flatten
      p.points = Card.calculate_points(won_cards)
    end
  end

  def previous_trick
    @tricks[-2]
  end

  def next_player
    if !current_trick
      # first trick lead
      @players[0]
    elsif !current_trick.started
      # lead a new trick
      # in this scenario previous trick should always exist
      @players[previous_trick.winning_player_id]
    else
      last_player_id = current_trick.last_player_id
      # p "last_player_postion: #{last_player_position}"
      next_player_id = (last_player_id + 1) % 4
      # p "next_player_postion: #{next_player_position}"
      @players[next_player_id]
    end
  end
end
