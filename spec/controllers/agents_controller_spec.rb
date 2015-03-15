require 'rails_helper'

RSpec.describe AgentsController, type: :controller, wip: true do
  let(:agent) { create :agent }

  context "for user without administrator role" do
    shared_examples_for 'blocker' do
      it "raises UnauthorizedException" do
        expect(action).to raise_exception(ApplicationController::UnauthorizedException)
      end
    end

    before(:each) { session[:user_id] = nil }

    describe "GET #index" do
      let(:action) { -> { get :index } }
      it_should_behave_like 'blocker'
    end

    describe "GET #show" do
      let(:action) { -> { get :show, id: agent } }
      it_should_behave_like 'blocker'
    end

    describe "GET #edit" do
      let(:action) { -> { get :edit, id: agent } }
      it_should_behave_like 'blocker'
    end

    describe "PATCH #update" do
      let(:action) { -> { patch :update, id: agent } }
      it_should_behave_like 'blocker'
    end
  end

  context "for user with administrator role" do
    before(:each) { session[:user_id] = create(:administrator).id }

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, id: agent
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #edit" do
      it "returns http success" do
        get :edit, id: agent
        expect(response).to have_http_status(:success)
      end
    end
  end
end
