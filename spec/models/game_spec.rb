require 'test_helper'

RSpec.describe Game do
  describe '.create' do
    it 'sets up a new game' do
      game = Game.create
      expect(game.players.length).to eq(4)
      expect(game.cards.length).to eq(54)

      expect(game.talon.length).to eq(2)
      expect(game.tricks.length).to eq(1)
      expect(game.stage).to eq(:make_bid)

      game.players.each do |player|
        expect(player.cards.length).to eq(12)
      end
    end
  end
  
  describe '.play_card' do
    let(:game) { Game.create(talon_resolved: true, talon_picked: true, king: 'something') }

    before do
      allow(Bid).to receive(:finished?).with(game).and_return(:true)
      allow(Bid).to receive(:pick_talon?).with(game).and_return(:false)
    end

    it 'should play card' do
      card = game.players[0].cards[0]
      game.play_current_trick!(card.slug)

      expect(game.tricks.length).to eq(1)
      expect(game.tricks[0].cards.length).to eq(4)
    end
  end

  it 'should pick talon' do
    game = Game.create
    game.pick_talon!(0)
    expect(game.players[0].cards.length).to eq(15)
  end

  it 'should put down discards' do
    game = Game.create
    game.pick_talon!(0)
    card_slugs = game.players[0].cards[0..2].map(&:slug)
    game.resolve_talon!(card_slugs)
    expect(game.players[0].cards.length).to eq(12)
  end
end
