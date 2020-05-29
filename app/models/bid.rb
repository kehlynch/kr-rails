class Bid < ApplicationRecord
  include Kontrable
  include Biddable

  RUFER = 'rufer'
  SOLO = 'solo'
  DREIER = 'dreier'
  BESSER_RUFER = 'besser_rufer'
  SOLO_DREIER = 'solo_dreier'

  PICCOLO = 'piccolo'
  BETTEL = 'bettel'

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

  belongs_to :game
  belongs_to :game_player

  validates :slug, inclusion: { in: RANKED_SLUGS }

  def self.second_round_finished?(winning_bid)
    first_round_finished? && (winning_bid.slug != RUFER)
  end

  def self.first_round_finished?
    passed_player_count >= 3
  end

  def self.passed_player_count
    select do |bid|
      bid.slug == PASS
    end.map(&:game_player_id).uniq.size
  end

  def rank
    RANKED_SLUGS.index(slug) || 0
  end

  def talon?
    PICK_TALON_SLUGS.include?(slug)
  end

  def king?
    PICK_KING_SLUGS.include?(slug)
  end

  def trischaken?
    TRISCHAKEN == slug
  end

  def announcements?
    ![PICCOLO, BETTEL, TRISCHAKEN].include?(slug)
  end

  def announcements_doubled?
    [SOLO, SOLO_DREIER].include?(slug)
  end

  def negative?
    [PICCOLO, BETTEL, TRISCHAKEN].include?(slug)
  end

  def declarer_leads?
    [BETTEL].include?(slug)
  end

  def contracted_trick_count
    return 1 if slug == PICCOLO
    return 0 if slug == BETTEL
    return nil
  end

  def points
    POINTS[slug]
  end
end
