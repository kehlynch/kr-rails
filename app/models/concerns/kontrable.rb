module Kontrable
  extend ActiveSupport::Concern

  KONTRAS = {
    'kontra' => [nil, 2],
    'rekontra' => [2, 4],
    'subkontra' => [4, 8]
  }

  def self.kontra_name(current_kontra_level)
    KONTRAS.find do |_name, levels|
      levels[0] == current_kontra_level
    end[0]
  end

  def self.find_kontrable(slug)
    _name, _slug, id = slug.split('-')

    Bid.find_by(id: id.to_i) || Announcement.find_by(id: id.to_i)
  end

  # other team can kontra or subcontra
  def kontra_slug
    return nil if slug == 'pass'

    return kontrable_slug if [nil, 4].include?(kontra)
  end

  # announcer can rekontra if kontrad
  def rekontra_slug
    return kontrable_slug if kontra == 2
  end

  def kontrable_slug
    "#{Kontrable.kontra_name(kontra)}-#{slug}-#{id}"
  end

  def update_kontra(slug)
    name, _slug, _id = slug.split('-')
    kontra_level = KONTRAS[name][1]

    update(kontra: kontra_level)
  end

  def kontra_multiplier
    kontra || 1
  end
end
