require 'spec_helper'

RSpec.describe AnnouncementPointsContext do
  let(:declarers) { instance_double(PlayerTeam, :declarers) }
  let(:defence) { instance_double(PlayerTeam, :defence) }
  let(:tricks) { instance_double(Tricks, :tricks) }
  let(:game) { instance_double(Game, :game, tricks: tricks, king: 'king-slug') }
  let(:subject) { described_class.new(declarers: declarers, defence: defence, game: game) }
  let(:trick) { instance_double(Trick, :trick) }
  let(:card) { nil }
  let(:points) { 0 }
  let(:king) { instance_double(AnnouncementPoints::King, :king, points: points) }
  let(:bird) { instance_double(AnnouncementPoints::Bird, :bird, points: points) }

  before do
    allow(tricks).to receive(:last).and_return(trick)
    allow(declarers).to receive(:announced?).and_return(false)
    allow(defence).to receive(:announced?).and_return(false)
    allow(declarers).to receive(:tricks).and_return([])
    allow(defence).to receive(:tricks).and_return([])
    allow(AnnouncementPoints::King).to receive(:new).and_return(king)
    allow(AnnouncementPoints::Bird).to receive(:new).and_return(bird)
  end

  describe 'initialize' do
    it 'works' do
      described_class.new(declarers: declarers, defence: defence, game: game)
    end
  end

  describe '.declarer_points' do
    it 'works' do
      subject.team_points(declarers)
    end
  end
end
