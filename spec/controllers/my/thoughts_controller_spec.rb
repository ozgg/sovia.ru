require 'spec_helper'

describe My::ThoughtsController do
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
      let!(:public_thought) { create(:thought, user: owner) }
      let!(:protected_thought) { create(:protected_thought, user: owner) }
      let!(:private_thought) { create(:private_thought, user: owner) }
      let!(:other_thought) { create(:thought) }

      before(:each) { get :index }

      it "assigns user's public thoughts to @entries" do
        expect(assigns[:entries]).to include(public_thought)
      end

      it "assigns user's protected thoughts to @entries" do
        expect(assigns[:entries]).to include(protected_thought)
      end

      it "assigns user's private thoughts to @entries" do
        expect(assigns[:entries]).to include(private_thought)
      end

      it "doesn't assign other thoughts to @entries" do
        expect(assigns[:entries]).not_to include(other_thought)
      end

      it "renders my/thoughts/index" do
        expect(response).to render_template('my/thoughts/index')
      end
    end
  end
end