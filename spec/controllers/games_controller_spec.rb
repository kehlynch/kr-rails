require 'spec_helper'

RSpec.describe GamesController do

  describe 'GET edit' do
    let(:match_id) { 'match-id' }
    let(:game_id) { 'game-id' }
    let(:game) { instance_double('Game', :game) }
    let(:stage) { instance_double('StagePresenter', :game) }
    let(:players) { instance_double('PlayersPresenter', :players) }
    let(:bids) { instance_double('BidsPresenter', :bids) }
    let(:tricks) { instance_double('TricksPresenter', :tricks) }
    let(:hand) { [] }

    before do
      allow(Game).to receive(:find).with(game_id).and_return(game)
      allow(StagePresenter).to receive(:new).with(game_id).and_return(stage)
      allow(PlayersPresenter).to receive(:new).with(game_id).and_return(players)
      allow(BidsPresenter).to receive(:new).with(game_id).and_return(bids)
      allow(TricksPresenter).to receive(:new).with(game_id).and_return(tricks)

      # allow(players).to receive(:human_hand).and_return(hand)
      # allow(tricks).to receive(:current_trick_finished?).and_return('stage')
    end

    it 'renders the edit template' do
      get :edit, params: { match_id: match_id, id: game_id }
      expect(response).to render_template('edit')
    end

    it 'assigns' do
      get :edit, params: { match_id: match_id, id: game_id }
      expect(assigns(:game)).to eq(game)
      expect(assigns(:stage)).to eq(stage)
      expect(assigns(:players)).to eq(players)
      expect(assigns(:bids)).to eq(bids)
      expect(assigns(:tricks)).to eq(tricks)
    end
  end
end
