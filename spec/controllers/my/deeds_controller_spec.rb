require 'spec_helper'

describe My::DeedsController do
  context "when user is not logged in" do
    before(:each) { session[:user_id] = nil }

    context "get index" do
      before(:each) { get :index }

      it "redirects to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "adds flash notice #{I18n.t('please_log_in')}" do
        expect(flash[:notice]).to eq(I18n.t('please_log_in'))
      end
    end
  end

  context "when user is logged in" do
    let(:user) { create(:user) }
    before(:each) { session[:user_id] = user.id }

    context "get index" do
      it "assigns user's deed to @deeds" do
        deed = create(:deed, user: user)
        get :index
        expect(assigns[:deeds]).to include(deed)
      end

      it "doesn't assign another user's deeds to @deeds" do
        deed = create(:deed)
        get :index
        expect(assigns[:deeds]).not_to include(deed)
      end
    end
  end
end
