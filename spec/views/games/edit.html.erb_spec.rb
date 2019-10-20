require 'spec_helper'

RSpec.describe 'games/edit.html.erb' do
  let(:match_id) { 'match-id' }
  let(:game) { stub_model(Game) }
  let(:stage) { instance_double('StagePresenter', :stage) }
  let(:players) { instance_double('PlayersPresenter', :players) }
  let(:bids) { instance_double('BidsPresenter', :bids) }
  let(:tricks) { instance_double('TricksPresenter', :tricks) }
  let(:player) { instance_double('Player', :player) }
  let(:hand) { [] }
  let(:message) { ['message'] }
  let(:valid_bids) { [] }
  let(:human_declarer?) { true }
  let(:show_talon?) { false }
  let(:action) { 'action' }


  let(:cards) { [] }

  before do
    assign(:match_id, match_id)
    assign(:game, game)
    assign(:stage, stage)
    assign(:players, players)
    assign(:bids, bids)
    assign(:tricks, tricks)

    allow(players).to receive(:human_hand).and_return(hand)
    allow(players).to receive(:human_player).and_return(player)
    allow(players).to receive(:each)

    allow(player).to receive(:name).and_yield('name')

    allow(stage).to receive(:action).and_return(action)
    allow(stage).to receive(:show_talon?).and_return(show_talon?)
    allow(stage).to receive(:message).and_return(message)

    allow(player).to receive(:cards).and_return(cards)

    allow(bids).to receive(:finished?).and_return(false)
    allow(bids).to receive(:valid_bids).and_return(valid_bids)
    allow(bids).to receive(:human_declarer?).and_return(human_declarer?)
    allow(bids).to receive(:winning_bid_name).and_return('')

    allow(tricks).to receive(:current_trick_finished?).and_return(false)
    allow(tricks).to receive(:trick_cards).and_return([])
  end

  describe 'when action is make_bid' do
    let(:action) { 'make_bid' }
    let(:valid_bids) { [['solo', 'Solo']] }

    it 'renders sucessfully' do
      render
    end

    it 'displays available bids' do
      render

      expect(rendered).to have_content('Solo')
    end

    it 'should render bid' do
      render

      expect(rendered).to include('bid-buttons-container')
    end
  end

  describe 'when action is pick_king' do
    let(:action) { 'pick_king' }

    it 'renders sucessfully' do
      render
    end

    it 'should render kings' do
      render

      expect(rendered).to include('kings-container')
    end

    context 'when declarer is not human' do
      let(:human_declarer?) { false }

      it 'should render kings' do
        render

        expect(rendered).to include('kings-container')
      end
    end
  end

  describe 'showing the talon' do
    before do
      allow(game).to receive(:talon_picked).and_return(0)
    end

    it 'renders sucessfully' do
      render
    end

    context 'when it should show' do
      let(:show_talon?) { true }

      it 'should render talon' do
        render

        expect(rendered).to include('talon-container')
      end
    end

    context 'when it should not show' do
      let(:show_talon?) { false }

      it 'should not render talon' do
        render

        expect(rendered).not_to include('talon-container')
      end
    end
  end

  describe 'when action is play_card' do
    let(:action) { 'play_card' }

    before do
    end

    it 'renders sucessfully' do
      render
    end
  end

  describe 'when action is finished' do
    let(:action) { 'finished' }

    before do
    end

    it 'renders sucessfully' do
      render
    end
  end
end
