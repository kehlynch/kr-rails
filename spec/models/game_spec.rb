require 'test_helper'

RSpec.describe Game do
  let(:subject) { described_class.new }

  describe '.deal_game' do
    it 'sets up a new game' do
      game = described_class.deal_game
      expect(game.players.length).to eq(4)
      expect(game.cards.length).to eq(54)

      expect(game.talon.length).to eq(2)
      expect(game.tricks.length).to eq(0)
      expect(game.stage).to eq(:make_bid)

      game.players.each do |player|
        expect(player.cards.length).to eq(12)
      end
    end
  end
  
  describe '#play_card' do
    let(:tricking) { instance_double('Tricking', :tricking) }
    before do
      allow(Tricking).to receive(:new).and_return(tricking)
      allow(tricking).to receive(:play_current_trick!)
    end

    it 'should play card' do
      subject.play_current_trick!('cardslug')

      expect(tricking).to have_received(:play_current_trick!).with('cardslug')
    end
  end

  it 'should pick talon' do
    game = Game.deal_game
    game.pick_talon!(0)
    expect(game.players[0].cards.length).to eq(15)
  end

  it 'should put down discards' do
    game = Game.deal_game
    game.pick_talon!(0)
    card_slugs = game.players[0].cards[0..2].map(&:slug)
    game.resolve_talon!(card_slugs)
    expect(game.players[0].cards.length).to eq(12)
  end
end
