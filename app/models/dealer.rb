class Dealer
  def self.deal(game, players)
    # @cards = []
    card_params = (1..8).map do |value|
      %i[club diamond heart spade].map do |suit|
        {suit: suit, value: value}
      end
    end.flatten

    trump_card_params = (1..22).map do |value|
      {suit: :trump, value: value}
    end

    card_params.concat(trump_card_params).shuffle.each do |params|
      p 'params', params
      game.cards.add(**params)
    end

    talon = game.cards.first(6)
    talon.first(3).each do |card|
      card.update(talon_half: 0)
    end

    talon.last(3).each do |card|
      card.update(talon_half: 1)
    end

    game.cards.reverse_order.limit(48).in_batches(of: 12).each_with_index do |hand_cards, i|
      # TODO can we update_all somehow here?
      # hand_cards.each { |c| c.update(game_player: players[i]) }
      hand_cards.update_all(game_player_id: players[i].id)
    end

    # @cards.each(&:save!)
  end
end
