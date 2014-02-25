require 'spec_helper'

describe My::RecoveriesController do
  context "when user is logged in" do
    before(:each) { session[:user_id] = create(:user).id }

    shared_examples "logged in bouncer" do
      it "redirects to root page" do
        expect(response).to redirect_to(root_path)
      end

      it "adds flash notice #{I18n.t('session.already_logged_in')}" do
        expect(flash[:notice]).to eq(I18n.t('session.already_logged_in'))
      end
    end

    context "get show" do
      before(:each) { get :show }

      it_should_behave_like "logged in bouncer"
    end

    context "post create" do
      before(:each) { post :create }

      it_should_behave_like "logged in bouncer"
    end

    context "patch update" do
      before(:each) { patch :update }

      it_should_behave_like "logged in bouncer"
    end
  end
end