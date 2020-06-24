class Announcement < ApplicationRecord
  include Kontrable
  include Biddable

  belongs_to :game
  belongs_to :game_player
  before_save :record_kontra

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

  def record_kontra
    if slug.include?('kontra')
      kontrable = Kontrable.find_kontrable(slug)
      kontrable.update_kontra(slug)
    end
  end
end
