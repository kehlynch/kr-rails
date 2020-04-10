class Bids < BidsBase
  RUFER = 'rufer'
  SOLO = 'solo'
  DREIER = 'dreier'
  BESSER_RUFER = 'besser_rufer'
  SOLO_DREIER = 'solo_dreier'

  PICCOLO = 'piccolo'
  BETTEL = 'bettel'
  # PICCOLO_OUVERT = 'piccolo_ouvert'
  # BETTEL_OUVERT = 'piccolo_ouvert'

  CALL_KING = 'call_king'
  TRISCHAKEN = 'trischaken'
  SECHSERDREIER = 'sechserdreier'

  FIRST_ROUND_SLUGS = [PASS, RUFER, SOLO, PICCOLO, BESSER_RUFER, BETTEL, DREIER, SOLO_DREIER]
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
    PICCOLO => 2,
    DREIER => 3,
    BETTEL => 3,
    SOLO_DREIER => 6
  }

  def valid?(slug)
    valid_bids.include?(slug)
  end

  def valid_bids
    if first_round_finished?
      return [PASS] unless highest&.player.id == next_bidder.id

      return RUFER_SLUGS if highest&.slug == RUFER

			return []
    else
      return [PASS] if any? { |b| b.slug == PASS && b.player == next_bidder }

      lowest_rank = next_bidder.forehand? ? highest_rank : highest_rank + 1

      slugs_for_rank_up(lowest_rank, next_bidder.forehand? && empty?)
    end
  end

  def slugs_for_rank_up(rank, no_pass)
    rank = rank == 0 ? 1 : rank
    slugs = FIRST_ROUND_SLUGS[rank..] || []
    
    slugs = [PASS] + slugs unless no_pass

    return slugs
  end

  def finished?
    first_round_finished? && (highest&.slug != RUFER)
  end

  def first_round_finished?
    passed_players = 
      filter { |b| b.slug == 'pass' }.map(&:player_id).uniq.count

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
    max_by do |b|
      [b.rank, b.player.forehand? ? 1 : 0]
    end
  end

  def highest_rank
    highest&.rank || 0
  end

  def declarer
    finished? ? highest&.player : nil
  end

  def lead
    # this will change for Bettle etc
    highest&.declarer_leads? ? declarer : @players.forehand
  end

  def first_bidder
    return @players.forehand
  end

  def next_bidder
    return first_bidder if empty?

    @players.next_from(last.player)
  end

  def get_bot_bid
    next_bidder.pick_bid(valid_bids)
  end

  def add_bid!(bid_slug)
    Bid.create(slug: bid_slug, game_id: @game.id, player_id: next_bidder.id)
  end
end
