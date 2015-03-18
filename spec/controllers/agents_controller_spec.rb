require 'rails_helper'

RSpec.describe AgentsController, type: :controller do
  let(:agent) { create :agent }
  let(:user) { create :administrator }

  before :each do
    session[:user_id] = user.id
    expect(controller).to receive(:allow_administrators_only)
  end

  shared_examples 'successful response' do
    it "returns HTTP success" do
      expect(response).to have_http_status(:success)
    end
  end

  shared_examples 'setting agent' do
    it "assigns Agent to @agent" do
      expect(assigns(:agent)).to eq(agent)
    end
  end

  describe "GET #index" do
    before(:each) { get :index }

    it "assigns list of agents to @agents" do
      expect(assigns(:agents)).not_to be_nil
    end

    it_should_behave_like 'successful response'
  end

  describe "GET #show" do
    before(:each) { get :show, id: agent }

    it_should_behave_like 'setting agent'
    it_should_behave_like 'successful response'
  end

  describe "GET #edit" do
    before(:each) { get :edit, id: agent }

    it_should_behave_like 'setting agent'
    it_should_behave_like 'successful response'
  end

  describe "PATCH #update" do
    before(:each) { patch :update, id: agent, agent: { is_bot: true } }

    it_should_behave_like 'setting agent'

    it "redirects to agent" do
      expect(response).to redirect_to(agent)
    end
  end
end
