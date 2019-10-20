class Bids
  PASS = 'pass'
  RUFER = 'rufer'
  SOLO = 'solo'
  DREIER = 'dreier'

  CALL_KING = 'call_king'
  TRISCHAKEN = 'trischaken'
  SECHSERDREIER = 'sechserdreier'

  FIRST_ROUND_SLUGS = [PASS, RUFER, SOLO, DREIER]
  RUFER_SLUGS = [CALL_KING, TRISCHAKEN, SECHSERDREIER]

  RANKED_SLUGS = FIRST_ROUND_SLUGS + RUFER_SLUGS

  PICK_TALON_SLUGS = [DREIER, CALL_KING, SECHSERDREIER]
  PICK_KING_SLUGS = [CALL_KING, SOLO]

  POINTS = {
    CALL_KING => 1,
    TRISCHAKEN => 1,
    SECHSERDREIER => 3,
    SOLO => 2,
    DREIER => 3
  }

  attr_reader :bids

  delegate :each, :map, to: :bids

  def initialize(game_id)
    @game_id = game_id
    @bids = Bid.where(game_id: game_id).sort_by(&:bidding_order)
    @players = Players.new(game_id)
  end

  def make_bid!(bid_slug)
    add_bid!(bid_slug)
    until !next_bidder || next_bidder.human? || finished?
      bid_slug = next_bidder.pick_bid
      add_bid!(bid_slug)
    end
  end

  def available_bids(player)
    return [] unless player == next_bidder
    if first_round_finished?
      return [PASS] unless declarer == player

      return RUFER_SLUGS if highest&.slug == RUFER

      raise 'bidding finished'
    else
      return [PASS] if @bids.any? { |b| b.slug == PASS && b.player == player }

      lowest_rank = player.forehand? ? highest_rank : highest_rank + 1

      slugs_for_rank_up(lowest_rank, player.forehand? && @bids.empty?)
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

  def pick_talon?
    finished? && highest&.talon?
  end

  def pick_king?
    finished? && highest&.king?
  end

  def highest
    @bids.sort_by { |b| "#{b.rank}#{b.player.forehand?}" }.last
  end

  def highest_rank
    highest&.rank || 0
  end

  def declarer
    finished? && highest&.player
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
    @bids << Bid.create(slug: bid_slug, game_id: @game_id, player: next_bidder)
  end
end
