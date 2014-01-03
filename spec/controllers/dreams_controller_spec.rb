require 'spec_helper'

describe DreamsController do
  let(:user) { create(:user) }

  shared_examples "visible dream" do
    it "assigns dream to @dream" do
      expect(assigns[:dream]).to be_a(Dream)
    end

    it "renders dreams/show" do
      expect(response).to render_template('dreams/show')
    end
  end

  shared_examples "any user" do
    context "get index" do
      before(:each) do
        create(:dream)
        get :index
      end

      it "assigns public dreams to @dreams" do
        expect(assigns[:dreams]).not_to be_empty
        expect(assigns[:dreams].first).to be_a(Dream)
      end

      it "renders dreams/index view" do
        expect(response).to render_template('dreams/index')
      end
    end

    context "get show for public anonymous dream" do
      before(:each) { get :show, id: create(:dream) }

      it_should_behave_like "visible dream"
    end

    context "get show for public owned dream" do
      before(:each) { get :show, id: create(:owned_dream) }

      it_should_behave_like "visible dream"
    end

    context "post create with invalid parameters" do
      it_should_behave_like "failed dream creation"
    end
  end

  shared_examples "restricted access" do
    it "redirects to dreams main page" do
      expect(response).to redirect_to(dreams_path)
    end

    it "adds flash message 'Недостаточно прав'" do
      expect(flash[:message]).to eq(I18n.t('roles.insufficient_rights'))
    end
  end

  shared_examples "added new dream" do
    it "creates new dream in database" do
      expect(action).to change(Dream, :count).by(1)
    end

    it "redirects to dream page" do
      action.call
      expect(response).to redirect_to(dream_path(Dream.last))
    end

    it "adds flash message 'Сон добален'" do
      action.call
      expect(flash[:message]).to eq(I18n.t('dream.added'))
    end
  end

  shared_examples "failed dream creation" do
    it "doesn't create dream in database"
    it "assigns new dream to @dream"
    it "renders dreams/new"
  end

  context "anonymous user" do
    before(:each) { session[:user_id] = nil }

    it_should_behave_like "any user"

    context "get show for users-only dream" do
      before(:each) { get :show, id: create(:protected_dream) }

      it_should_behave_like "restricted access"
    end

    context "get show for private dream" do
      before(:each) { get :show, id: create(:private_dream) }

      it_should_behave_like "restricted access"
    end

    context "get new" do
      before(:each) { get :new }

      it "assigns new dream to @dream" do
        expect(assigns[:dream]).to be_a(Dream)
      end

      it "renders dreams/new" do
        expect(response).to render_template('dreams/new')
      end
    end

    context "post create with valid parameters" do
      let(:action) { lambda { post :create, dream: { body: 'My good dream' } } }

      it "adds new dream with anonymous owner"

      it_should_behave_like "added new dream"
    end

    context "get edit" do
      before(:each) { get :edit, id: create(:dream) }

      it_should_behave_like "restricted access"
    end

    context "patch update" do
      before(:each) { patch :update, id: create(:dream), dream: { body: 'My good dream' } }

      it_should_behave_like "restricted access"
    end

    context "delete destroy" do
      before(:each) { delete :destroy, id: create(:dream) }

      it_should_behave_like "restricted access"
    end
  end

  context "authorized user" do
    let(:other_user) { create(:user) }
    before(:each) { session[:user_id] = user.id }

    it_should_behave_like "any user"

    context "get index" do
      it "assigns also user-only dreams to @dreams"
    end

    context "get show for user-only dream" do
      before(:each) { get :show, id: create(:protected_dream) }

      it_should_behave_like "visible dream"
    end

    context "get show for own private dream" do
      let(:dream) { create(:private_dream, user: user) }
      before(:each) { get :show, id: dream }

      it_should_behave_like "visible dream"
    end

    context "get show for others private dream" do
      before(:each) { get :show, id: create(:private_dream) }

      it_should_behave_like "restricted access"
    end

    context "post create with valid parameters" do
      let(:action) { lambda { post :create, dream: { body: 'My good dream' } } }

      it "adds new dream with current user as owner"
      it "increments dreams_count for current user"

      it_should_behave_like "added new dream"
    end

    context "get edit for own dream" do
      it "assigns edited dream to @dream"
      it "renders dreams/edit"
    end

    context "get edit for others dream" do
      before(:each) { get :edit, id: create(:owned_dream) }

      it_should_behave_like "restricted access"
    end

    context "patch update for own dream" do
      it "updates dream"
      it "adds flash message 'Сон изменён'"
      it "redirects to dream page"
    end

    context "patch update for others dream" do
      before(:each) { patch :update, id: create(:owned_dream) }

      it_should_behave_like "restricted access"
    end

    context "patch update for anonymous dream" do
      before(:each) { patch :update, id: create(:dream) }

      it_should_behave_like "restricted access"
    end

    context "delete destroy for own dream" do
      it "removes dream from database"
      it "decrements dreams_count for current user"
      it "redirects to all dreams page"
      it "adds flash message 'Сон удалён'"
    end

    context "delete destroy for others dream" do
      before(:each) { delete :destroy, id: create(:owned_dream) }

      it_should_behave_like "restricted access"
    end

    context "delete destroy for anonymous dream" do
      before(:each) { delete :destroy, id: create(:dream) }

      it_should_behave_like "restricted access"
    end
  end

  context "getting tagged dreams" do
    pending "describe tagged dreams"
  end
end