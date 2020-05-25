class Dealer
  def self.deal(game)
    # @cards = []
    card_params = (1..8).map do |value|
      %i[club diamond heart spade].map do |suit|
        {suit: suit, value: value}
      end
    end.flatten

    trump_card_params = (1..22).map do |value|
      {suit: :trump, value: value}
    end

    card_params = card_params.concat(trump_card_params).shuffle
    talon_card_params = card_params.pop(6)

    # card_params.concat(trump_card_params).shuffle.each do |params|
    #   p 'params', params
    #   game.cards.add(**params)
    # end

    talon_card_params.first(3).each do |params|
      game.cards.create(**params.merge(talon_half: 0))
    end

    talon_card_params.last(3).each do |params|
      game.cards.create(**params.merge(talon_half: 1))
    end

    card_params.in_groups_of(12).each_with_index do |params, i|
      params.each do |params|
        game.cards.create(**params.merge(game_player_id: game.game_players[i].id))
      end
    end
  end
end
