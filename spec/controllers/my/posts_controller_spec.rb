require 'spec_helper'

describe My::PostsController do
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
  end

  context "when user is logged in" do
    let(:owner) { create(:user) }

    before(:each) { session[:user_id] = owner.id }

    context "get index" do
      let!(:public_post) { create(:post, user: owner) }
      let!(:protected_post) { create(:protected_post, user: owner) }
      let!(:other_post) { create(:post) }

      before(:each) { get :index }

      it "assigns user's public posts to @entries" do
        expect(assigns[:entries]).to include(public_post)
      end

      it "assigns user's protected posts to @entries" do
        expect(assigns[:entries]).to include(protected_post)
      end

      it "doesn't assign other posts to @entries" do
        expect(assigns[:entries]).not_to include(other_post)
      end

      it "renders my/posts/index" do
        expect(response).to render_template('my/posts/index')
      end
    end
  end
end