class Talon

  attr_reader :talon

  delegate :each_with_index, to: :talon

  def initialize(game_id)
    @game_id = game_id

    @talon =
      Card
        .where(game_id: game_id)
        .where.not(talon_half: nil)
        .order(:id)
        .to_a
        .group_by(&:talon_half)
        .values
  end

  def pick_whole_talon!(player)
    @talon.flatten.each do |talon_card|
      talon_card.update(player: player)
    end
  end

  def pick_talon!(talon_half_index, player)
    talon_half_index = player.pick_talon_half_for(@game_id) if !talon_half_index

    @talon[talon_half_index].each do |talon_card|
      talon_card.update(player: player)
    end
  end

  def resolve_talon!(putdown_card_slugs, player)
    putdown_card_slugs = player.pick_putdowns_for(@game_id).map(&:slug) if !putdown_card_slugs

    player.cards_for(@game_id)
      .select { |card| putdown_card_slugs.include?(card.slug) }
      .each { |card| card.update(discard: true) }
  end

  def unpicked
    @talon.flatten.filter { |t| t.player_id.nil? }
  end
end
