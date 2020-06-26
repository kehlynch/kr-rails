class MatchPlayer < ApplicationRecord
  POSITIONS = [0, 1, 2, 3]
  before_save :allocate_position
  belongs_to :player
  belongs_to :match

  delegate :human, :name, to: :player

  def allocate_position
    taken_positions = match.match_players.map(&:position)
    p 'taken_positions', taken_positions
    self.position = (POSITIONS - taken_positions).sample
  end
end
