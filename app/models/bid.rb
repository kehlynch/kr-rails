class Bid < ApplicationRecord

  belongs_to :player
  belongs_to :game

  # these are in order
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

  NAMES = {
    RUFER =>'Rufer',
    SOLO =>'Solo',
    DREIER =>'Dreier',
    PASS =>'Pass'
  }

  validates :slug, inclusion: { in: RANKED_SLUGS }

  def name
    NAMES[slug]
  end

  def self.available_bids(game, player)
    if Bid.first_round_finished?(game)
      return [PASS] unless Bid.declarer(game) == player

      return RUFER_SLUGS if Bid.highest(game)&.slug == RUFER

      raise 'bidding finished'
    else
      return [PASS] if Bid.find_by(game: game, player: player, slug: PASS)

      highest_bid_rank = Bid.highest(game)&.rank || 0

      if player.forehand?
        return FIRST_ROUND_SLUGS[highest_bid_rank..] if highest_bid_rank == 0

        return [PASS] + FIRST_ROUND_SLUGS[highest_bid_rank..]
      end

      return [PASS] + FIRST_ROUND_SLUGS[highest_bid_rank + 1..]
    end
  end

  def self.finished?(game)
    Bid.first_round_finished?(game) && !Bid.highest(game)&.slug == RUFER
  end

  def self.pick_talon?(game)
    Bid.first_round_finished?(game) && Bid.highest(game)&.talon?
  end

  def self.pick_king?(game)
    Bid.first_round_finished?(game) && Bid.highest(game)&.king?
  end

  def self.highest(game)
    game.bids.max_by(&:rank)
  end

  def self.declarer(game)
    Bid.highest(game).player
  end

  def self.first_round_finished?(game)
    Bid.where(game_id: game.id, slug: PASS).distinct.count('player_id')
  end

  def rank
    RANKED_SLUGS.index(slug) || 0
  end

  def talon?
    [PICK_TALON_SLUGS].include?(slug)
  end

  def king?
    [PICK_KING_SLUGS].include?(slug)
  end
end
