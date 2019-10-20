require 'spec_helper'

RSpec.describe MessagePresenter do
  let(:game_id) { 'game-id' }
  let(:stage) { '' }
  let(:king) { nil }
  let(:subject) { described_class.new(game_id, stage) }
  let(:game) { instance_double(Game, :game, king: king) }
  let(:bids) { instance_double(Bids, :bids) }
  let(:tricks) { instance_double(Tricks, :game) }
  let(:player) { instance_double('Player', :player) }
  let(:bid) { instance_double('Bid', :bid) }
  let(:bid_slug) { 'bid-slug' }
  let(:bid_presenter) { instance_double('BidPresenter', :bid_presenter) }
  let(:bid_name) { 'bid-name' }
  let(:finished?) { false }
  let(:human_declarer) { true }

  before do
    allow(Game).to receive(:find).with(game_id).and_return(game)
    allow(Bids).to receive(:new).with(game_id).and_return(bids)
    allow(Tricks).to receive(:new).with(game_id).and_return(tricks)
    allow(game).to receive(:stage).and_return(stage)
    allow(game).to receive(:human_declarer?).and_return(true)
    allow(bids).to receive(:declarer).and_return(player)
    allow(game).to receive(:finished?).and_return(finished?)
    allow(bids).to receive(:highest).and_return(bid)
    allow(bid).to receive(:slug).and_return(bid_slug)
    allow(BidPresenter).to receive(:new).with(bid_slug).and_return(bid_presenter)
    allow(bid_presenter).to receive(:name).and_return(bid_name)
    allow(player).to receive(:human?).and_return(true)
  end

  describe 'message' do

    context 'pick_talon when human is declarer' do
      let(:human_declarer) { true }
      let(:stage) { 'pick_talon' }
      let(:bid_name) { 'bid-name' }

      it 'returns "pick talon"' do
        expect(subject.message).to eq(['You declare bid-name.', 'Pick talon.'])
      end
    end
  end
end
