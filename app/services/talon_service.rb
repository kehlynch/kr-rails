class TalonService

  attr_reader :talon, :cards

  delegate :each_with_index, :flatten, :map, to: :talon
  delegate :find, to: :cards

  def initialize(game)
    @game_id = game.id
    @talon = game.talon_cards.sort_by(&:id).group_by(&:talon_half).values
    @cards = @talon.flatten
  end

  def pick_whole_talon!(game_player)
    @talon.flatten.each do |talon_card|
      talon_card.update(game_player_id: game_player.id)
    end
  end

  def pick_talon!(talon_half_index, game_player)
    talon_half_index ||= game_player.pick_talon

    @talon[talon_half_index].each do |talon_card|
      talon_card.update(game_player_id: game_player.id)
    end

    return talon_half_index
  end

  def resolve_talon!(putdown_card_slugs, game_player)
    putdown_card_slugs = game_player.pick_putdowns.map(&:slug) if !putdown_card_slugs

    game_player.hand_cards
      .select { |card| putdown_card_slugs.include?(card.slug) }
      .each { |card| card.update(discard: true) }
  end
end
