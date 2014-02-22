require 'spec_helper'

describe DreamsController do
  let(:tag) { create(:dream_tag, name: 'Волшебство') }
  let(:owner) { create(:user) }
  let(:user) { create(:user) }
  let(:entry) { create(:dream, user: owner, body: 'Эталон', tags: [tag]) }

  shared_examples "dream assigner" do
    it "assigns dream to @entry" do
      expect(assigns[:entry]).to eq(entry)
    end
  end

  shared_examples "dream redirector" do
    it "redirects to dream path" do
      expect(response).to redirect_to(entry)
    end
  end

  shared_examples "restricted management" do
    it "raises error for dreams management" do
      expect { get :edit, id: entry }.to raise_error(ApplicationController::UnauthorizedException)
      expect { patch :update, id: entry }.to raise_error(ApplicationController::UnauthorizedException)
      expect { delete :destroy, id: entry }.to raise_error(ApplicationController::UnauthorizedException)
    end
  end

  shared_examples "restricted showing" do
    it "raises error for dream showing" do
      expect { get :show, id: entry }.to raise_error(ApplicationController::UnauthorizedException)
    end
  end

  shared_examples "allowed showing" do
    context "get index" do
      let!(:private_entry) { create(:private_dream) }

      before(:each) { get :index }

      it "assigns dreams list to @entries" do
        expect(assigns[:entries]).to include(entry)
      end

      it "doesn't include private dream to @entries" do
        expect(assigns[:entries]).not_to include(private_entry)
      end

      it "renders dreams/index" do
        expect(response).to render_template('dreams/index')
      end
    end

    context "get show" do
      before(:each) { get :show, id: entry }

      it "renders dreams/show" do
        expect(response).to render_template('dreams/show')
      end

      it_should_behave_like "dream assigner"
    end
  end

  shared_examples "allowed creating" do
    context "get new" do
      before(:each) { get :new }

      it "renders dreams/new" do
        expect(response).to render_template('dreams/new')
      end

      it "assigns new dream to @entry" do
        expect(assigns[:entry]).to be_a_new(Entry::Dream)
      end
    end

    context "post create with valid parameters" do
      before(:each) { post :create, entry_dream: { body: 'b' } }

      it "assigns a new dream to @entry" do
        expect(assigns[:entry]).to be_an(Entry::Dream)
      end

      it "creates a new dream" do
        expect(assigns[:entry]).to be_persisted
      end

      it "adds flash notice #{I18n.t('entry.dream.created')}" do
        expect(flash[:notice]).to eq(I18n.t('entry.dream.created'))
      end

      it "redirects to created dream" do
        expect(response).to redirect_to(Entry::Dream.last)
      end
    end

    context "post create with invalid parameters" do
      before(:each) { post :create, entry_dream: { body: ' ' } }

      it "assigns a new dream to @entry" do
        expect(assigns[:entry]).to be_an(Entry::Dream)
      end

      it "leaves entries table intact" do
        expect(assigns[:entry]).not_to be_persisted
      end

      it "renders dreams/new" do
        expect(response).to render_template('dreams/new')
      end
    end
  end

  shared_examples "allowed management" do
    context "get edit" do
      before(:each) { get :edit, id: entry }

      it "renders dreams/edit" do
        expect(response).to render_template('dreams/edit')
      end

      it_should_behave_like "dream assigner"
    end

    context "patch update with valid parameters" do
      before(:each) { patch :update, id: entry, entry_dream: { title: 'a', body: 'b' } }

      it "updates dream" do
        entry.reload
        expect(entry.title).to eq('a')
      end

      it "adds flash notice #{I18n.t('entry.dream.updated')}" do
        expect(flash[:notice]).to eq(I18n.t('entry.dream.updated'))
      end

      it_should_behave_like "dream assigner"
      it_should_behave_like "dream redirector"
    end

    context "patch update with invalid parameters" do
      before(:each) { patch :update, id: entry, entry_dream: { body: ' ' } }

      it "leaves dream intact" do
        entry.reload
        expect(entry.body).to eq('Эталон')
      end

      it "renders dreams/edit" do
        expect(response).to render_template('dreams/edit')
      end

      it_should_behave_like "dream assigner"
    end

    context "delete destroy" do
      let(:action) { -> { delete :destroy, id: entry } }

      before(:each) { entry.valid? }

      it "removes dream from database" do
        expect(action).to change(Entry::Dream, :count).by(-1)
      end

      it "adds flash notice #{I18n.t('entry.dream.deleted')}" do
        action.call
        expect(flash[:notice]).to eq(I18n.t('entry.dream.deleted'))
      end
    end
  end

  context "when current user is anonymous" do
    before(:each) { session[:user_id] = nil }

    it_should_behave_like "allowed showing"
    it_should_behave_like "restricted management"

    context "when dream is protected" do
      let!(:entry) { create(:protected_dream, user: owner) }

      it_should_behave_like "restricted showing"
      it_should_behave_like "restricted management"

      context "get index" do
        it "doesn't add protected dream to @entries" do
          get :index
          expect(assigns[:entries]).not_to include(entry)
        end
      end
    end

    context "when dream is private" do
      let!(:entry) { create(:private_dream, user: owner) }

      it_should_behave_like "restricted showing"
      it_should_behave_like "restricted management"
    end
  end

  context "when current user is not moderator or owner" do
    before(:each) { session[:user_id] = user.id }

    it_should_behave_like "allowed showing"
    it_should_behave_like "restricted management"
    it_should_behave_like "allowed creating"

    context "when dream is protected" do
      let(:entry) { create(:protected_dream, user: owner) }

      it_should_behave_like "allowed showing"
      it_should_behave_like "restricted management"
    end

    context "when dream is private" do
      let!(:entry) { create(:private_dream, user: owner) }

      it_should_behave_like "restricted showing"
      it_should_behave_like "restricted management"
    end
  end

  context "when current user is owner" do
    before(:each) { session[:user_id] = owner.id }

    it_should_behave_like "allowed showing"
    it_should_behave_like "allowed creating"
    it_should_behave_like "allowed management"

    context "when dream is protected" do
      let(:entry) { create(:protected_dream, user: owner, body: 'Эталон') }

      it_should_behave_like "allowed showing"
      it_should_behave_like "allowed management"
    end

    context "when dream is private" do
      let(:entry) { create(:private_dream, user: owner, body: 'Эталон') }

      context "get show" do
        before(:each) { get :show, id: entry }

        it "renders dreams/show" do
          expect(response).to render_template('dreams/show')
        end

        it_should_behave_like "dream assigner"
      end

      it_should_behave_like "allowed management"
    end
  end

  context "when current user is moderator" do
    before(:each) { session[:user_id] = create(:moderator).id }

    it_should_behave_like "allowed showing"
    it_should_behave_like "allowed creating"
    it_should_behave_like "allowed management"

    context "when dream is protected" do
      let(:entry) { create(:protected_dream, user: owner, body: 'Эталон') }

      it_should_behave_like "allowed showing"
      it_should_behave_like "allowed management"
    end

    context "when dream is private" do
      let!(:entry) { create(:private_dream, user: owner) }

      it_should_behave_like "restricted showing"
      it_should_behave_like "restricted management"
    end
  end

  context "getting random dream" do
    before(:each) do
      create(:dream)
      get :random
    end

    it "assigns random pubilc dream to @entry" do
      expect(assigns[:entry]).to be_an(Entry::Dream)
    end

    it "renders dreams/random" do
      expect(response).to render_template('dreams/random')
    end
  end

  context "getting dreams of user" do
    let!(:public_dream) { create(:dream, user: owner) }
    let!(:protected_dream) { create(:protected_dream, user: owner) }
    let!(:private_dream) { create(:private_dream, user: owner) }
    let!(:other_dream) { create(:dream) }

    shared_examples "common visible dreams" do
      it "has public dream in @entries" do
        expect(assigns[:entries]).to include(public_dream)
      end

      it "hasn't private dream in @entries" do
        expect(assigns[:entries]).not_to include(private_dream)
      end

      it "hasn't other dream in @entries" do
        expect(assigns[:entries]).not_to include(other_dream)
      end

      it "renders dreams/dreams_of_user" do
        expect(response).to render_template('dreams/dreams_of_user')
      end
    end

    context "anonymous user" do
      before(:each) do
        session[:user_id] = nil
        get :dreams_of_user, login: owner.login
      end

      it_should_behave_like "common visible dreams"

      it "hasn't protected dream in @entries" do
        expect(assigns[:entries]).not_to include(protected_dream)
      end
    end

    context "logged in user" do
      before(:each) do
        session[:user_id] = user.id
        get :dreams_of_user, login: owner.login
      end

      it_should_behave_like "common visible dreams"

      it "has protected dream in @entries" do
        expect(assigns[:entries]).to include(protected_dream)
      end
    end
  end

  context "getting tagged dreams" do
    let!(:other_dream) { create(:dream, tags: [create(:dream_tag)]) }
    let!(:protected_dream) { create(:protected_dream, tags: [tag]) }
    let!(:private_dream) { create(:private_dream, tags: [tag]) }

    shared_examples "visible public tagged dreams" do
      before(:each) { get :tagged, tag: tag.name }

      it "includes tagged dream to @entries" do
        expect(assigns[:entries]).to include(entry)
      end

      it "doesn't include another dream to @entries" do
        expect(assigns[:entries]).not_to include(other_dream)
      end

      it "doesn't include private dream to @entries" do
        expect(assigns[:entries]).not_to include(private_dream)
      end
    end

    context "anonymous user" do
      before(:each) { session[:user_id] = nil }

      it_should_behave_like "visible public tagged dreams"

      it "doesn't include protected dream to @entries" do
        get :tagged, tag: tag.name
        expect(assigns[:entries]).not_to include(protected_dream)
      end
    end

    context "logged in user" do
      before(:each) { session[:user_id] = user.id }

      it_should_behave_like "visible public tagged dreams"

      it "includes protected dream to @entries" do
        get :tagged, tag: tag.name
        expect(assigns[:entries]).to include(protected_dream)
      end
    end
  end
end
