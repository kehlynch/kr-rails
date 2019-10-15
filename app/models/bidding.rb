class Bidding
  PASS = 'pass'
  RUFER = 'rufer'
  SOLO = 'solo'
  DREIER = 'dreier'

  CALL_KING = 'call_king'
  TRISCHAKEN = 'trischaken'
  SECHSERDREIER = 'sechserdreier'

  FIRST_ROUND_SLUGS = [RUFER, SOLO, DREIER]
  RUFER_SLUGS = [CALL_KING, TRISCHAKEN, SECHSERDREIER]

  RANKED_SLUGS = [PASS] + FIRST_ROUND_SLUGS + RUFER_SLUGS

  PICK_TALON_SLUGS = [RUFER, DREIER]
  PICK_KING_SLUGS = [CALL_KING, SOLO]

  def initialize(game_id)
    @game_id = game_id
    @bids = Bid.where(game_id: game_id)
  end

  def make_bid!(bid_slug)
    add_bid!(bid_slug)
    until next_bidder.human || finished?
      bid_slug = next_bidder.pick_bid
      add_bid!(bid_slug)
    end
  end

  def add_bid!(bid_slug)
    Bid.create(slug: bid_slug, game_id: @game_id, player: next_bidder)
    @bids.reload
  end

  def available_bids(player)
    if first_round_finished?
      return [PASS] unless declarer == player

      return RUFER_SLUGS if highest&.slug == RUFER

      raise 'bidding finished'
    else
      return [PASS] if @bids.find_by(slug: PASS)

      if player.forehand?
        return FIRST_ROUND_SLUGS[highest_rank..] if highest_rank == 0

        return [PASS] + FIRST_ROUND_SLUGS[highest_rank..]
      end

      return [PASS] + FIRST_ROUND_SLUGS[highest_rank + 1..]
    end
  end

  def finished?
    first_round_finished? && !(highest&.slug == RUFER)
  end

  def first_round_finished?
    @bids.where(slug: PASS).distinct.count('player_id') == 3
  end

  def pick_talon?
    first_round_finished? && highest&.talon?
  end

  def pick_king?
    first_round_finished? && highest&.king?
  end

  def highest
    @bids.max_by(&:rank)
  end

  def highest_rank
    highest&.rank || 0
  end

  def declarer
    highest&.player
  end

  def next_bidder
    if @bids.empty?
      return Player.find_by(game_id: @game_id, human: true)
    else
      return Player.next_from(@bids[-1].player)
    end
  end
end
