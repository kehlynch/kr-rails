class ValidBidsService
  def initialize(game)
    @game = game
    @bids = game.bids
  end

  def valid?(slug)
    valid_bids.include?(slug)
  end

  def valid_bids
    if bids.first_round_finished?
      return [Bid::PASS] unless bids.highest&.game_player.id == next_player.id

      return Bid::RUFER_SLUGS if winning_bid_slug == Bid::RUFER

			return []
    else
      return [Bid::PASS] if next_player_already_passed?

      lowest_rank = next_player_forehand? ? highest_rank : highest_rank + 1

      slugs_for_rank_up(lowest_rank, next_player_forehand? && empty?)
    end
  end

  private

  attr_reader :game, :bids

  delegate(
    :next_player,
    :next_player_forehand?,
    to: :game
  )

  delegate(
    :highest,
    :empty?,
    to: :bids
  )

  def highest_rank
    highest&.rank || 0
  end

  def winning_bid_slug
    highest&.slug
  end

  def next_player_already_passed?
    bids.any? { |b| b.slug == Bid::PASS && b.game_player == next_player }
  end

  def slugs_for_rank_up(rank, no_pass)
    rank = rank == 0 ? 1 : rank
    slugs = Bid::FIRST_ROUND_SLUGS[rank..] || []
    
    slugs = [Bid::PASS] + slugs unless no_pass

    return slugs
  end
end
