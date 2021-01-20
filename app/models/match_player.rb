class MatchPlayer < ApplicationRecord
  before_save :allocate_position
  belongs_to :player
  belongs_to :match

  delegate :human, :name, to: :player

  def allocate_position
    self.position = (match.match_players.pluck(:position).max || -1) + 1
  end
end
