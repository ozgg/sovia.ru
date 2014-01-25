require 'spec_helper'

describe MyController do
  context "anonymous user" do
    before(:each) { session[:user_id] = nil }

    shared_examples "login redirector" do
      it "redirects to login path" do
        expect(response).to redirect_to(login_path)
      end

      it "adds flash message #{I18n.t('please_log_in')}" do
        expect(flash[:message]).to eq(I18n.t('please_log_in'))
      end
    end

    context "get index" do
      before(:each) { get :index }

      it_should_behave_like "login redirector"
    end

    context "get dreams" do
      before(:each) { get :dreams }

      it_should_behave_like "login redirector"
    end
  end

  context "logged in user" do
    let(:user) { create(:user) }
    before(:each) { session[:user_id] = user.id }

    context "get index" do
      before(:each) { get :index }

      it "renders my/index" do
        expect(response).to render_template('my/index')
      end
    end

    context "get dreams" do
      it "renders my/dreams" do
        get :dreams
        expect(response).to render_template('my/dreams')
      end

      it "adds public user dreams to @dreams" do
        dream = create(:dream, user: user)
        get :dreams
        expect(assigns[:dreams]).to include(dream)
      end

      it "adds protected user dreams to @dreams" do
        dream = create(:protected_dream, user: user)
        get :dreams
        expect(assigns[:dreams]).to include(dream)
      end

      it "adds private user dreams to @dreams" do
        dream = create(:private_dream, user: user)
        get :dreams
        expect(assigns[:dreams]).to include(dream)
      end

      it "doesn't add anonymous dreams to @dreams" do
        dream = create(:dream)
        get :dreams
        expect(assigns[:dreams]).not_to include(dream)
      end

      it "doesn't add others protected dreams to @dreams" do
        dream = create(:protected_dream)
        get :dreams
        expect(assigns[:dreams]).not_to include(dream)
      end

      it "doesn't add others private dreams to @dreams" do
        dream = create(:private_dream)
        get :dreams
        expect(assigns[:dreams]).not_to include(dream)
      end
    end
  end
end
