require 'spec_helper'

RSpec.describe Bids do
  let(:game_id) { 'game-id' }
  let(:subject) { described_class.new(game_id) }
  let(:match_id) { 'match-id' }
  let(:game) { instance_double('Game', :game, match_id: match_id) }
  let(:players) { instance_double('Players', :players) }
  let(:player) { instance_double('Player', :player) }
  let(:forehand?) { true }
  let(:bids) { [] }

  before do
    allow(Game).to receive(:find).with(game_id).and_return(game)
    allow(Bid).to receive(:where).and_return(bids)
    allow(Players).to receive(:new).and_return(players)
    allow(players).to receive(:forehand).and_return(player)
    allow(player).to receive(:forehand_for?).with(game_id).and_return(true)
  end

  describe '.valid_bids' do
    context 'when player is forehand' do
      let(:forehand?) { true }

      it 'returns all first round bids without pass' do
        expect(subject.valid_bids).to eq(['rufer', 'solo', 'dreier'])
      end

      # context 'when player is not forehand' do
      #   before do
      #     allow(player).to receive(:forehand?).and_return(true)
      #     allow(Player).to receive(:human_player_for).and_return(player)
      #     let(:bid) { instance_double
      #   end
      # end
    end
  end

  describe '.first_round_finished' do
    context 'when no bids made' do
      let(:bids) { [] }
      it 'returns false' do
        expect(subject.first_round_finished?).to eq(false)
      end
    end

    context '.when 3 players have passed' do
      let(:bids) { 3.times.collect { |i| instance_double('Bid', slug: 'pass', player_id: i, bidding_order: i) } }
      it 'returns true' do
        expect(subject.first_round_finished?).to eq(true)
      end
    end
  end
end
