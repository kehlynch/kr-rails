class Talon

  attr_reader :talon, :cards

  delegate :each_with_index, :flatten, :map, to: :talon
  delegate :find, to: :cards

  def initialize(cards, game)
    @game_id = game.id
    @talon = cards.select do |c|
      c.talon_half.present? 
    end.sort_by(&:id).group_by(&:talon_half).values
    @cards = @talon.flatten
  end

  def pick_whole_talon!(player)
    @talon.flatten.each do |talon_card|
      talon_card.update(player_id: player.id)
    end
  end

  def pick_talon!(talon_half_index, player)
    talon_half_index = player.pick_talon_half_for(@game_id) if !talon_half_index

    @talon[talon_half_index].each do |talon_card|
      talon_card.update(player_id: player.id)
    end
  end

  def resolve_talon!(putdown_card_slugs, player)
    putdown_card_slugs = player.pick_putdowns.map(&:slug) if !putdown_card_slugs

    player.hand
      .select { |card| putdown_card_slugs.include?(card.slug) }
      .each { |card| card.update(discard: true) }
  end

  def unpicked
    @talon.flatten.filter { |t| t.player_id.nil? }
  end
end
