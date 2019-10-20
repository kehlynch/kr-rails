require 'spec_helper'

RSpec.describe StagePresenter do
  let(:game_id) { 'game-id' }
  let(:subject) { described_class.new(game_id) }
  let(:game) { instance_double(Game, :game) }
  let(:tricks) { instance_double(Tricks, :tricks) }
  let(:message_presenter) { instance_double(MessagePresenter, :message_presenter) }
  let(:stage) { '' }

  before do
    allow(Game).to receive(:find).with(game_id).and_return(game)
    allow(Tricks).to receive(:new).with(game_id).and_return(tricks)
    allow(MessagePresenter).to receive(:new).with(game_id, stage).and_return(message_presenter)
    allow(game).to receive(:stage).and_return(stage)
  end

  describe 'message' do
    let(:message) { 'message' }

    before do
      allow(message_presenter).to receive(:message).and_return(message)
    end

    it 'returns the message from the message presenter' do
      expect(subject.message).to eq(message)
    end
  end

  describe 'action' do
    let(:stage) { 'stage' }
    let(:current_trick_finished?) { false }
    before do
      allow(tricks).to receive(:current_trick_finished?).and_return(current_trick_finished?)
    end

    it 'returns the stage' do
      expect(subject.action).to eq(stage)
    end

    context 'when the current trick has finished' do
      let(:stage) { 'play_card' }
      let(:current_trick_finished?) { true }
      it 'returns next_trick' do
        expect(subject.action).to eq('next_trick')
      end
    end

  end
end
