class Game < ApplicationRecord
  has_many :cards
  has_many :players, -> { order(:position) }
  has_many :tricks, -> { order(:trick_index) }
  has_many :bids, -> { order(:bid_index) }

  def self.deal_game
    game = Game.create
    game.players = 
      4.times.collect do |i|
        Player.create(game: game, human: i == 0, position: i)
      end

    Dealer.deal(game, game.players)

    game
  end

  def bidding
    @bidding ||= Bidding.new(id)
  end

  def tricking
    @tricking ||= Tricking.new(id)
  end
  
  def talon
    cards.select { |c| !c.talon_half.nil? }.group_by(&:talon_half).values.to_a
  end

  def stage
    return :make_bid unless bidding.finished?
    
    return :pick_king if bidding.pick_king? && !king.nil?

    if @bidding.pick_talon?
      return :pick_talon unless talon_picked

      return :resolve_talon unless talon_resolved
    end

    return :play_card unless tricking.finished?

    return :finished
  end

  def winner
    players.max_by(&:points)
  end

  def pick_talon!(talon_half_index)
    talon[talon_half_index].each do |talon_card|
      # assume player 0 for now
      talon_card.update(talon_half: nil, player: human_player)
    end

    update(talon_picked: true)

    reload
  end

  def resolve_talon!(card_slugs)
    # assume player 0 for now
    human_player.cards
      .select { |card| card_slugs.include?(card.slug) }
      .each { |card| card.update(discard: true) }

    human_player.reload

    update(talon_resolved: true)
  end

  def play_current_trick!(card_slug = nil)
    tricking.play_current_trick!(card_slug)
  end

  def play_next_trick!
    tricking.play_next_trick!
  end

  def make_bid!(bid_slug)
    bidding.make_bid!(bid_slug)
  end

  def human_player
    players.find { |p| p.human }
  end

  def current_trick
    tricking.current_trick
  end

  private

end
