require 'spec_helper'

describe DeedsController do
  context "get index" do
    before(:each) { get :index }

    it "renders deeds/index" do
      expect(response).to render_template('deeds/index')
    end
  end

  context "when user is not logged in" do
    let(:deed) { create(:deed) }

    before(:each) { session[:user_id] = nil }

    shared_examples "login redirector" do
      it "redirects to login path" do
        expect(response).to redirect_to(login_path)
      end

      it "adds flash notice #{I18n.t('please_log_in')}" do
        expect(flash[:notice]).to eq(I18n.t('please_log_in'))
      end
    end

    context "get new" do
      before(:each) { get :new }

      it_should_behave_like "login redirector"
    end

    context "post create" do
      before(:each) { post :create }

      it_should_behave_like "login redirector"
    end

    context "get show" do
      before(:each) { get :show, id: deed }

      it_should_behave_like "login redirector"
    end

    context "get edit" do
      before(:each) { get :edit, id: deed }

      it_should_behave_like "login redirector"
    end

    context "patch update" do
      before(:each) { patch :update, id: deed }

      it_should_behave_like "login redirector"
    end

    context "delete destroy" do
      before(:each) { delete :destroy, id: deed }

      it_should_behave_like "login redirector"
    end
  end

  context "when user is logged in" do
    let(:user) { create(:user) }
    let!(:deed) { create(:deed, user: user) }
    before(:each) { session[:user_id] = user.id }

    context "get new" do
      before(:each) { get :new }

      it "assigns new Deed to @deed" do
        expect(assigns[:deed]).to be_a_new(Deed)
      end

      it "renders deeds/new" do
        expect(response).to render_template('deeds/new')
      end
    end

    context "post create with valid attributes" do
      before(:each) { post :create, deed: { name: 'Another good deed' } }

      it "assigns Deed to @deed" do
        expect(assigns[:deed]).to be_a(Deed)
      end

      it "persists Deed in @deed" do
        expect(assigns[:deed]).to be_persisted
      end

      it "sets current user as deed owner" do
        expect(Deed.last.user).to eq(user)
      end

      it "adds flash notice #{I18n.t('deed.created')}" do
        expect(flash[:notice]).to eq(I18n.t('deed.created'))
      end

      it "redirects to my deeds" do
        expect(response).to redirect_to(my_deeds_path)
      end
    end

    context "post create with invalid parameters" do
      let(:action) { -> { post :create, deed: { name: ' ' } } }

      it "assigns Deed to @deed" do
        action.call
        expect(assigns[:deed]).to be_a(Deed)
      end

      it "leaves Deeds table intact" do
        expect(action).not_to change(Deed, :count)
      end

      it "renders deeds/new" do
        action.call
        expect(response).to render_template('deeds/new')
      end
    end

    context "get edit" do
      before(:each) { get :edit, id: deed }

      it "assigns deed to @deed" do
        expect(assigns[:deed]).to eq(deed)
      end

      it "renders deeds/edit" do
        expect(response).to render_template('deeds/edit')
      end
    end

    context "patch update with valid parameters" do
      before(:each) { patch :update, id: deed, deed: { name: 'new name' } }

      it "assigns deed to @deed" do
        expect(assigns[:deed]).to eq(deed)
      end

      it "updates deed name" do
        deed.reload
        expect(deed.name).to eq('new name')
      end

      it "redirects to deed path" do
        expect(response).to redirect_to(deed)
      end

      it "adds flash notice #{I18n.t('deed.updated')}" do
        expect(flash[:notice]).to eq(I18n.t('deed.updated'))
      end
    end

    context "patch update with invalid parameters" do
      let(:action) { -> { patch :update, id: deed, deed: { name: ' ' } } }

      it "assigns deed to @deed" do
        action.call
        expect(assigns[:deed]).to eq(deed)
      end

      it "leaves deed name intact" do
        expect(action).not_to change(deed, :name)
      end

      it "renders deeds/edit" do
        action.call
        expect(response).to render_template('deeds/edit')
      end
    end

    context "delete destroy" do
      let(:action) { -> { delete :destroy, id: deed } }

      it "destroys deed" do
        expect(action).to change(Deed, :count).by(-1)
      end

      it "redirects to my deeds" do
        action.call
        expect(response).to redirect_to(my_deeds_path)
      end
    end

    context "when managing others deeds" do
      let(:other_deed) { create(:deed) }

      it "doesn't allow to see deed" do
        expect { get :show, id: other_deed }.to raise_error(ApplicationController::UnauthorizedException)
      end

      it "doesn't allow to edit deed" do
        expect { get :edit, id: other_deed }.to raise_error(ApplicationController::UnauthorizedException)
      end

      it "doesn't allow to update deed" do
        expect { patch :update, id: other_deed }.to raise_error(ApplicationController::UnauthorizedException)
      end

      it "doesn't allow to destroy deed" do
        expect { delete :destroy, id: other_deed }.to raise_error(ApplicationController::UnauthorizedException)
      end
    end
  end
end
