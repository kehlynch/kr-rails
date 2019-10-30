class Bids
  PASS = 'pass'
  RUFER = 'rufer'
  SOLO = 'solo'
  DREIER = 'dreier'
  BESSER_RUFER = 'besser_rufer'
  SOLO_DREIER = 'solo_dreier'

  # PICCOLO = 'piccolo'
  # BETTEL = 'bettel'
  # PICCOLO_OUVERT = 'piccolo_ouvert'
  # BETTEL_OUVERT = 'piccolo_ouvert'

  CALL_KING = 'call_king'
  TRISCHAKEN = 'trischaken'
  SECHSERDREIER = 'sechserdreier'

  FIRST_ROUND_SLUGS = [PASS, RUFER, SOLO, BESSER_RUFER, DREIER, SOLO_DREIER]
  RUFER_SLUGS = [CALL_KING, TRISCHAKEN, SECHSERDREIER]

  RANKED_SLUGS = FIRST_ROUND_SLUGS + RUFER_SLUGS

  PICK_TALON_SLUGS = [DREIER, CALL_KING, SECHSERDREIER, BESSER_RUFER]
  PICK_KING_SLUGS = [CALL_KING, SOLO, BESSER_RUFER]

  POINTS = {
    CALL_KING => 1,
    TRISCHAKEN => 1,
    SECHSERDREIER => 3,
    BESSER_RUFER => 1,
    SOLO => 2,
    DREIER => 3,
    SOLO_DREIER => 6
  }

  attr_reader :bids

  delegate :each, :map, :select, to: :bids

  def initialize(bids, game)
    @game = game
    @bids = bids.sort_by(&:bidding_order)
    @players = game.players
  end

  def make_bid!(bid_slug)
    add_bid!(bid_slug) if bid_slug
    until !next_bidder || next_bidder.human? || finished?
      bid_slug = next_bidder.pick_bid(valid_bids)
      add_bid!(bid_slug)
    end
  end

  def valid_bids
    if first_round_finished?
      return [PASS] unless highest&.player.id == next_bidder.id

      return RUFER_SLUGS if highest&.slug == RUFER

      raise 'bidding finished'
    else
      return [PASS] if @bids.any? { |b| b.slug == PASS && b.player == next_bidder }

      lowest_rank = next_bidder.forehand? ? highest_rank : highest_rank + 1

      slugs_for_rank_up(lowest_rank, next_bidder.forehand? && @bids.empty?)
    end
  end

  def slugs_for_rank_up(rank, no_pass)
    rank = rank == 0 ? 1 : rank
    slugs = FIRST_ROUND_SLUGS[rank..] || []
    
    slugs = [PASS] + slugs unless no_pass

    return slugs
  end

  def finished?
    first_round_finished? && !(highest&.slug == RUFER)
  end

  def started?
    return @bids.empty?
  end

  def first_round_finished?
    passed_players = 
      @bids.filter { |b| b.slug == 'pass' }.map(&:player_id).uniq.count

    passed_players >= 3
  end

  def talon_cards_to_pick
    return nil if !finished? || !highest&.talon?

    return 6 if highest&.slug == SECHSERDREIER 

    return 3
  end

  def pick_king?
    finished? && highest&.king?
  end

  def bird_required?
    finished? && highest.slug == BESSER_RUFER
  end

  def highest
    @bids.sort_by do |b|
      "#{b.rank}#{b.player.forehand?}"
    end.last
  end

  def highest_rank
    highest&.rank || 0
  end

  def declarer
    finished? ? highest&.player : nil
  end

  def lead
    # this will change for Bettle etc
    @players.forehand
  end

  def next_bidder
    if @bids.empty?
      return @players.forehand
    else
      return @players.next_from(@bids[-1].player)
    end
  end

  private

  def add_bid!(bid_slug)
    @bids << Bid.create(slug: bid_slug, game_id: @game.id, player_id: next_bidder.id)
  end
end
