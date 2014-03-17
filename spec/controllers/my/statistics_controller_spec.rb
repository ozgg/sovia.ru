require 'spec_helper'

describe My::StatisticsController do
  context "when user is not logged in" do
    before(:each) { session[:user_id] = nil }

    shared_examples "login redirector" do
      it "redirects to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "adds flash notice #{I18n.t('please_log_in')}" do
        expect(flash[:notice]).to eq(I18n.t('please_log_in'))
      end
    end

    context "get index" do
      before(:each) { get :index }

      it_should_behave_like "login redirector"
    end

    context "get tags" do
      before(:each) { get :tags }

      it_should_behave_like "login redirector"
    end
  end

  context "when user is logged in" do
    let(:user) { create(:user) }

    before(:each) { session[:user_id] = user.id }

    context "get index" do
      before(:each) { get :index }

      it "renders my/statistics/index" do
        expect(response).to render_template('my/statistics/index')
      end
    end

    context "get tags" do
      let!(:used_tag) { create(:dream_tag) }
      let!(:unused_tag) { create(:dream_tag, name: 'unused') }

      before(:each) do
        create(:dream, user: user, tags: [used_tag])
        get :tags
      end

      it "renders my/statistics/tags" do
        expect(response).to render_template('my/statistics/tags')
      end

      it "assigns used tags to @tags" do
        personal_tag = UserTag.find_by(user: user, tag: used_tag)
        expect(assigns[:tags]).to include(personal_tag)
      end
    end
  end
end
