class Announcement < ApplicationRecord
  include Kontrable
  include Biddable

  belongs_to :game
  belongs_to :game_player

  PASS = 'pass'
  PAGAT = 'pagat'
  UHU = 'uhu'
  KAKADU = 'kakadu'
  KING = 'king'
  FORTY_FIVE = 'forty_five'
  VALAT = 'valat'

  SLUGS = [PAGAT, UHU, KAKADU, KING, FORTY_FIVE, VALAT]

  def self.last_passed_player
    reorder(id: :desc).find_by(slug: PASS)&.game_player
  end

  def self.create(slug, game_player)
    add_kontra!(slug) if slug.include?('kontra')
    super(slug: slug, game_player: game_player)
  end

  def self.add_kontra!(kontra_slug)
    kontrable = Kontrable.find_kontrable(kontra_slug)
    kontrable.update_kontra(kontra_slug)
  end
end
