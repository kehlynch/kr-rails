class Game < ApplicationRecord
  belongs_to :match
  has_many :cards
  attr_reader :bids, :tricks, 

  def self.deal_game(match_id, players)
    game = Game.create(match_id: match_id)

    Dealer.deal(game, players)

    return game
  end

  def stage
    return 'make_bid' unless bids.finished?

    return 'pick_king' if bids.pick_king? && king.nil?

    if !bids.talon_cards_to_pick.nil? 
      unless talon_picked
        return 'pick_whole_talon' if bids.talon_cards_to_pick == 6
        return 'pick_talon'
      end

      unless talon_resolved
        return 'resolve_whole_talon' if bids.talon_cards_to_pick == 6
        return 'resolve_talon'
      end
    end

    # return 'first_trick' if tricks.first_trick?

    return 'play_card' unless tricks.finished?

    return 'finished'
  end

  def bids
    @bids ||= Bids.new(id)
  end

  def tricks
    @tricks ||= Tricks.new(id)
  end

  def players
    @players ||= Players.new(id)
  end
  
  def talon
    @talon ||= Talon.new(id)
  end

  def winners
    PlayerTeams.new(id).winners
  end

  def pick_king!(king_slug)
    self.king = king_slug || declarer.pick_king_for(id)
    save
  end

  def pick_talon!(talon_half_index)
    talon.pick_talon!(talon_half_index, declarer)

    update(talon_picked: talon_half_index)
  end

  def pick_whole_talon!
    talon.pick_whole_talon!(declarer)

    # TODO urgh - sort this out!
    update(talon_picked: 3)
  end

  def resolve_talon!(putdown_card_slugs)
    talon.resolve_talon!(putdown_card_slugs, declarer)

    update(talon_resolved: true)
  end

  def play_current_trick!(card_slug = nil)
    tricks.play_current_trick!(card_slug)
  end

  def play_next_trick!
    tricks.play_next_trick!
  end

  def make_bid!(bid_slug)
    bids.make_bid!(bid_slug)
    # if bids.finished? && !human_declarer?
    #   self.king = declarer.pick_king if bids.pick_king?
    # end
  end

  def human_player
    players.human_player
  end

  def human_declarer?
    declarer == human_player
  end

  def declarer
    bids.declarer
  end

  def partner
    PlayerTeams.new(id).partner
  end

  def current_trick
    tricks.current_trick
  end

  def current_trick_finished?
    tricks.current_trick_finished?
  end
  
  def finished?
    tricks.finished?
  end

  private

end
