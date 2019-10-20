require 'spec_helper'

RSpec.describe Game do
  let(:subject) { described_class.new }
  let(:bids) { instance_double('Bids', :bids) }
  let(:tricks) { instance_double('Tricks', :tricks) }
  let(:players) { instance_double('Players', :players) }
  let(:player) { instance_double('Player', :player) }
  let(:talon) { instance_double('Talon', :talon) }

  before do
    allow(Bids).to receive(:new).and_return(bids)
    allow(bids).to receive(:declarer).and_return(player)
    allow(Players).to receive(:new).and_return(players)
    allow(players).to receive(:human_player).and_return(player)
    allow(Talon).to receive(:new).and_return(talon)
    allow(Tricks).to receive(:new).and_return(tricks)
  end

  describe '.deal_game' do
    before do
      allow(Dealer).to receive(:deal)
      allow(Player).to receive(:create)
    end

    it 'sets up a new game' do
      expect(Dealer).to receive(:deal)
      expect(Player).to receive(:create).exactly(4).times

      described_class.deal_game
    end
  end
  
  describe '#play_card' do
    let(:tricks) { instance_double('Tricks', :tricks) }
    before do
      allow(tricks).to receive(:play_current_trick!)
    end

    it 'should play card' do
      subject.play_current_trick!('cardslug')

      expect(tricks).to have_received(:play_current_trick!).with('cardslug')
    end
  end

  describe 'pick_talon!' do
    before do
      allow(talon).to receive(:pick_talon!)
    end

    it 'should pick talon' do
      subject.pick_talon!(0)

      expect(talon).to have_received(:pick_talon!).with(0, player)
    end
  end

  describe 'resolve_talon!' do
    let(:card_slugs) { instance_double(Array, :card_slugs) }

    before do
      allow(talon).to receive(:resolve_talon!)
    end

    it 'should put down discards' do
      subject.resolve_talon!(card_slugs)

      expect(talon).to have_received(:resolve_talon!).with(card_slugs, player)
    end
  end
end
