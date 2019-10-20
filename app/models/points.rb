class Points
  attr_reader :game

  delegate :declarers, :defence, to: :game

  def self.points_for_cards(cards)
    cards.map(&:points).in_groups_of(3).reduce(0) do |acc, group|
      group.compact!
      total = group.length > 1 ? group.sum + 1 : group.sum
      p "#{group.map{|p| p + 1}}: #{total}"
      acc + total
    end
  end

  def self.individual_points_for(player)
    points_for_cards(player.scorable_cards)
  end
end
