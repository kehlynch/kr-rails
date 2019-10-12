class XCard < ApplicationRecord
  self.table_name = 'cards'
  def self.build(suit, value, player_id = nil, legal = true)
    p 'building'
    params = {
      slug: "#{suit}_#{value}"
    }
    XCard.new(params)
  end
end
