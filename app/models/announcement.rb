class Announcement < ApplicationRecord
  include Kontrable
  include Biddable

  belongs_to :game
  belongs_to :game_player

  default_scope { order(:id).includes(:game_player) }

  PASS = 'pass'
  PAGAT = 'pagat'
  UHU = 'uhu'
  KAKADU = 'kakadu'
  KING = 'king'
  FORTY_FIVE = 'forty_five'
  VALAT = 'valat'

  SLUGS = [
    PAGAT,
    UHU,
    KAKADU,
    KING,
    FORTY_FIVE,
    VALAT
  ]

  # def self.next_bidder
  #   return nil unless any?

  #   return last.game_player if last.slug != PASS

  #   return last.game_player.next_game_player
  # end

  def self.last_passed_player
    order(:id).find_by(slug: PASS)&.game_player
  end

  def self.finished?
    return false unless pluck(:game_player_id).uniq.count == 4

    last(3).map(&:slug) == [PASS, PASS, PASS]
  end

  def self.create(slug, game_player)
    add_kontra!(slug) if slug.include?('kontra')
    super(slug: slug, game_player: game_player)
  end

  def self.add_kontra!(kontra_slug)
    kontrable = Kontrable.find_kontrable(kontra_slug)
    kontrable.update_kontra(kontra_slug)
  end

  def is_kontra?
    slug.include?('kontra')
  end
end
