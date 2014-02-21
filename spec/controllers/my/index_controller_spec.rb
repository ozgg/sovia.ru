require 'spec_helper'

describe My::IndexController do
  let(:user) { create(:user) }

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
    before(:each) { session[:user_id] = user.id }

    context "get index" do
      before(:each) { get :index }

      it "renders my/index/index" do
        expect(response).to render_template('my/index/index')
      end
    end
  end
end
