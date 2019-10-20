class Points
  def self.points_for_cards(cards)
    cards.map(&:points).in_groups_of(3).reduce(0) do |acc, group|
      group.compact!
      total = group.length > 1 ? group.sum + 1 : group.sum
      acc + total
    end
  end

  def self.individual_points_for(player, game_id)
    points_for_cards(player.scorable_cards_for(game_id))
  end
end
