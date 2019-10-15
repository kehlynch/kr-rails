require 'test_helper'

RSpec.describe Bidding do
  let(:subject) { described_class.new('game-id') }
  let(:player) { instance_double('Player', :player) }

  describe '.available_bids' do
    context 'when player is forehand' do
      before do
        allow(player).to receive(:forehand?).and_return(true)
      end

      it 'returns all first round bids without pass' do
        expect(subject.available_bids(player)).to eq(['rufer', 'solo', 'dreier'])
      end
    end
  end

  describe '.first_round_finished' do
    context 'when no bids made' do
      it 'returns false' do
        expect(subject.first_round_finished?).to eq(false)
      end
    end

    context '.when 3 players have passed' do
      it 'returns true' do
        game = Game.deal_game
        game.players[0..2].each { |p| Bid.create(game: game, slug: 'pass', player: p) }
        expect(Bidding.new(game.id).first_round_finished?).to eq(true)
      end
    end
  end
end
