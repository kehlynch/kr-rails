class Player < ApplicationRecord
  POSITIONS = [0, 1, 2, 3]
  belongs_to :match, optional: true
  has_many :games, through: :match

  before_save do |player|
    if player.name.blank?
      player.name = Names::NAMES.reject { |n| match.players.map(&:name).include?(n) }.sample
    end
  end

  def human?
    human
  end
end
