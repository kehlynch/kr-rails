class Game < ApplicationRecord

  after_create :generate_new_game
  
  has_many :cards
  has_many :players, -> { order(:position) }
  has_many :tricks, -> { order(:trick_index) }
  has_many :bids, -> { order(:bid_index) }

  def talon
    self.cards.select { |c| !c.talon_half.nil? }.group_by(&:talon_half).values.to_a
  end

  def stage
    return :finished if tricks.length == 12 && tricks[-1].finished?

    return :play_card if self.talon_resolved

    return :resolve_talon if self.talon_picked

    return :pick_talon if !self.king.nil?

    return :pick_king if !self.contract.nil?

    # TODO: need to implement first level of bidding to check here
    return :make_bid
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
    play_card(card_slug, next_player) if card_slug
    current_player = next_player
    until current_player.human || current_trick&.finished? || stage == :finished 
      card = current_player.pick_card
      play_card(card.slug, current_player)
      current_player = next_player
    end
  end

  def play_next_trick!
    Trick.create(game: self, trick_index: current_trick.trick_index + 1)
    play_current_trick!
  end

  def make_bid!(bid_slug)
    Bid.create(slug: bid_slug, game: self, player: next_player)
    reload
    current_player = next_player
    until current_player.human || Bid.finished_for(self)
      if current_player.can_bid?
        bid_slug = current_player.pick_bid
        Bid.create(slug: bid_slug, game: self, player: next_player)
        reload
      end
      current_player = next_player
    end
  end

  def play_next_trick!
    Trick.create(game: self, trick_index: current_trick.trick_index + 1)
    play_current_trick!
  end

  def human_player
    self.players.find { |p| p.human }
  end

  def current_trick
    self.tricks.last
  end

  private

  def generate_new_game
    players = 
      4.times.collect do |i|
        Player.create(game: self, human: i == 0, position: i)
      end

    Dealer.deal(self, players)

    Trick.create(game: self, trick_index: 0)
  end

  def play_card(card_slug, player)
    self.cards.find_by(slug: card_slug).update(played_index: next_played_index, trick: current_trick)
    reload
  end

  def next_played_index
    (self.cards.maximum(:played_index) || 0) + 1
  end

  def next_player
    if stage == :make_bid
      return next_bidder
    elsif stage == :play_card
      return next_card_player
    end
  end

  def next_bidder
    if bids.empty?
      return human_player
    else
      return Player.next_from(bids[-1].player)
    end
  end

  def next_card_player
    if !current_trick.started?
      # start of first trick - human player always leads for now
      return human_player if current_trick.trick_index == 0

      # start of another trick - winner of previous trick
      return tricks[-2]&.won_player if tricks[-2]&.won_player
    end

    # mid trick - find next player
    Player.next_from(current_trick.last_player)
  end
end
