require 'spec_helper'

describe My::DreamsController do
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
      let!(:public_dream) { create(:owned_dream, user: owner) }
      let!(:protected_dream) { create(:protected_dream, user: owner) }
      let!(:private_dream) { create(:private_dream, user: owner) }
      let!(:other_dream) { create(:dream) }

      before(:each) { get :index }

      it "assigns user's public dreams to @entries" do
        expect(assigns[:entries]).to include(public_dream)
      end

      it "assigns user's protected dreams to @entries" do
        expect(assigns[:entries]).to include(protected_dream)
      end

      it "assigns user's private dreams to @entries" do
        expect(assigns[:entries]).to include(private_dream)
      end

      it "doesn't assign other dreams to @entries" do
        expect(assigns[:entries]).not_to include(other_dream)
      end

      it "renders my/dreams/index" do
        expect(response).to render_template('my/dreams/index')
      end
    end
  end
end