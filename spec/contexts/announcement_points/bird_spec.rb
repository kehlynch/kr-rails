require 'spec_helper'

RSpec.describe AnnouncementPoints::Bird do
  let(:tricks) { instance_double(Tricks, :tricks) }
  let(:trick) { instance_double(Trick, :trick) }
  let(:team) { instance_double(PlayerTeam, :team) }
  let(:bird) { instance_double(Bird, :bird) }
  let(:multiplier) { 0 }
  let(:announced) { false }
  let(:number) { 1 }
  let(:player) { instance_double(Player, :player) }
  let(:card) { instance_double(Card, :card) }

  let(:subject) { described_class.new(number, team: team, tricks: tricks) }

  before do
    allow(AnnouncementPoints::Bird).to receive(:multiplier).and_return(multiplier)
    allow(team).to receive(:announced?).and_return(announced)
    allow(tricks).to receive(:[]).and_return(trick)
    allow(trick).to receive(:winning_player).and_return(player)
    allow(trick).to receive(:find_card).and_return(card)
    allow(trick).to receive(:winning_card).and_return(card)
  end

  describe '#points' do
    it 'returns 0 when not attempted' do
      expect(subject.points).to eq(0)
    end
  end
end
