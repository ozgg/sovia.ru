require 'spec_helper'

describe DreamsController do
  let(:owner) { create(:user) }
  let(:entry) { create(:dream, user: owner, body: 'Эталон') }

  shared_examples "dream assigner" do
    it "assigns dream to @entry" do
      expect(assigns[:entry]).to eq(entry)
    end
  end

  shared_examples "dream redirector" do
    it "redirects to post path" do
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
      let!(:entry) { create(:protected_dream, user: owner)}

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
      let!(:entry) { create(:private_dream, user: owner)}

      it_should_behave_like "restricted showing"
      it_should_behave_like "restricted management"
    end
  end

  context "when current user is not moderator or owner" do
    before(:each) { session[:user_id] = create(:user).id }

    it_should_behave_like "allowed showing"
    it_should_behave_like "restricted management"
    it_should_behave_like "allowed creating"

    context "when dream is protected" do
      let(:entry) { create(:protected_dream, user: owner)}

      it_should_behave_like "allowed showing"
      it_should_behave_like "restricted management"
    end

    context "when dream is private" do
      let!(:entry) { create(:private_dream, user: owner)}

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
      let(:entry) { create(:protected_dream, user: owner, body: 'Эталон')}

      it_should_behave_like "allowed showing"
      it_should_behave_like "allowed management"
    end

    context "when dream is private" do
      let(:entry) { create(:private_dream, user: owner, body: 'Эталон')}

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
      let(:entry) { create(:protected_dream, user: owner, body: 'Эталон')}

      it_should_behave_like "allowed showing"
      it_should_behave_like "allowed management"
    end

    context "when dream is private" do
      let!(:entry) { create(:private_dream, user: owner)}

      it_should_behave_like "restricted showing"
      it_should_behave_like "restricted management"
    end
  end
  
  
  
  #let(:user) { create(:user) }
  #let(:other_user) { create(:user) }
  #
  #shared_examples "visible dream" do
  #  it "assigns dream to @entry" do
  #    expect(assigns[:entry]).to be_a(Entry::Dream)
  #  end
  #
  #  it "renders dreams/show" do
  #    expect(response).to render_template('dreams/show')
  #  end
  #end
  #
  #shared_examples "any user" do
  #  context "get index" do
  #    let!(:public_dream) { create(:dream) }
  #    let!(:private_dream) { create(:private_dream) }
  #
  #    before(:each) { get :index }
  #
  #    it "assigns public dreams to @entries" do
  #      expect(assigns[:entries]).to include(public_dream)
  #    end
  #
  #    it "doesn't assign private dreams to @entries" do
  #      expect(assigns[:entries]).not_to include(private_dream)
  #    end
  #
  #    it "renders dreams/index view" do
  #      expect(response).to render_template('dreams/index')
  #    end
  #  end
  #
  #  context "get show for public anonymous dream" do
  #    before(:each) { get :show, id: create(:dream) }
  #
  #    it_should_behave_like "visible dream"
  #  end
  #
  #  context "get show for public owned dream" do
  #    before(:each) { get :show, id: create(:owned_dream) }
  #
  #    it_should_behave_like "visible dream"
  #  end
  #
  #  context "post create with invalid parameters" do
  #    let(:action) { lambda { post :create, dream: { body: ' ' } } }
  #
  #    it_should_behave_like "failed dream creation"
  #  end
  #end
  #
  #shared_examples "restricted access" do
  #  it "redirects to dreams main page" do
  #    expect(response).to redirect_to(dreams_path)
  #  end
  #
  #  it "adds flash message 'Недостаточно прав'" do
  #    expect(flash[:message]).to eq(I18n.t('roles.insufficient_rights'))
  #  end
  #end
  #
  #shared_examples "added new dream" do
  #  it "creates new dream in database" do
  #    expect(action).to change(Entry, :count).by(1)
  #  end
  #
  #  it "redirects to dream page" do
  #    action.call
  #    expect(response).to redirect_to(dream_path(Entry::Dream.last))
  #  end
  #
  #  it "adds flash message 'Сон добален'" do
  #    action.call
  #    expect(flash[:message]).to eq(I18n.t('entry.dream.added'))
  #  end
  #end
  #
  #shared_examples "editable dream" do
  #  before(:each) { get :edit, id: dream }
  #
  #  it "assigns edited dream to @entry" do
  #    expect(assigns[:entry]).to eq(dream)
  #  end
  #
  #  it "renders dreams/edit" do
  #    expect(response).to render_template('dreams/edit')
  #  end
  #end
  #
  #shared_examples "failed dream creation" do
  #  it "doesn't create dream in database" do
  #    expect(action).not_to change(Entry, :count)
  #  end
  #
  #  it "assigns new dream to @entry" do
  #    action.call
  #    expect(assigns[:entry]).to be_a_new(Entry::Dream)
  #  end
  #
  #  it "renders dreams/new" do
  #    action.call
  #    expect(response).to render_template('dreams/new')
  #  end
  #end
  #
  #shared_examples "successful dream update" do
  #  before(:each) { patch :update, id: dream, dream: { body: 'My good dream' } }
  #
  #  it "assigns dream to @entry" do
  #    expect(assigns[:entry]).to eq(dream)
  #  end
  #
  #  it "updates dream" do
  #    dream.reload
  #    expect(dream.body).to eq('My good dream')
  #  end
  #
  #  it "adds flash message 'Сон изменён'" do
  #    expect(flash[:message]).to eq(I18n.t('entry.dream.updated'))
  #  end
  #
  #  it "redirects to dream page" do
  #    expect(response).to redirect_to(dream_path(dream))
  #  end
  #end
  #
  #shared_examples "successful dream deletion" do
  #  let(:action) { lambda { delete :destroy, id: dream } }
  #
  #  it "removes dream from database" do
  #    expect(action).to change(Entry, :count).by(-1)
  #  end
  #
  #  it "redirects to all dreams page" do
  #    action.call
  #    expect(response).to redirect_to(dreams_path)
  #  end
  #
  #  it "adds flash message 'Сон удалён'" do
  #    action.call
  #    expect(flash[:message]).to eq(I18n.t('entry.dream.deleted'))
  #  end
  #end
  #
  #context "anonymous user" do
  #  before(:each) { session[:user_id] = nil }
  #
  #  it_should_behave_like "any user"
  #
  #  context "get index" do
  #    it "doesn't assign protected dreams to @entries" do
  #      protected_dream = create(:protected_dream)
  #      get :index
  #      expect(assigns[:entries]).not_to include(protected_dream)
  #    end
  #  end
  #
  #  context "get show for users-only dream" do
  #    before(:each) { get :show, id: create(:protected_dream) }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #
  #  context "get show for private dream" do
  #    before(:each) { get :show, id: create(:private_dream) }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #
  #  context "get new" do
  #    before(:each) { get :new }
  #
  #    it "assigns new dream to @entry" do
  #      expect(assigns[:entry]).to be_a(Entry::Dream)
  #    end
  #
  #    it "renders dreams/new" do
  #      expect(response).to render_template('dreams/new')
  #    end
  #  end
  #
  #  context "post create with valid parameters" do
  #    let(:action) { lambda { post :create, dream: { body: 'My good dream' } } }
  #
  #    it "adds new dream with anonymous owner" do
  #      action.call
  #      expect(Entry::Dream.last.user).to be_nil
  #    end
  #
  #    it_should_behave_like "added new dream"
  #  end
  #
  #  context "get edit" do
  #    before(:each) { get :edit, id: create(:dream) }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #
  #  context "patch update" do
  #    before(:each) { patch :update, id: create(:dream), dream: { body: 'My good dream' } }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #
  #  context "delete destroy" do
  #    before(:each) { delete :destroy, id: create(:dream) }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #end
  #
  #context "authorized user" do
  #  before(:each) { session[:user_id] = user.id }
  #
  #  it_should_behave_like "any user"
  #
  #  context "get index" do
  #    it "assigns also user-only dreams to @entries" do
  #      dream = create(:protected_dream)
  #      get :index
  #      expect(assigns[:entries]).to include(dream)
  #    end
  #  end
  #
  #  context "get show for user-only dream" do
  #    before(:each) { get :show, id: create(:protected_dream) }
  #
  #    it_should_behave_like "visible dream"
  #  end
  #
  #  context "get show for own private dream" do
  #    let(:dream) { create(:private_dream, user: user) }
  #    before(:each) { get :show, id: dream }
  #
  #    it_should_behave_like "visible dream"
  #  end
  #
  #  context "get show for others private dream" do
  #    before(:each) { get :show, id: create(:private_dream) }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #
  #  context "post create with valid parameters" do
  #    let(:action) { lambda { post :create, dream: { body: 'My good dream' } } }
  #
  #    it "adds new dream with current user as owner" do
  #      action.call
  #      expect(Entry::Dream.last.user).to eq(user)
  #    end
  #
  #    it_should_behave_like "added new dream"
  #  end
  #
  #  context "get edit for own dream" do
  #    let(:dream) { create(:dream, user: user) }
  #
  #    it_should_behave_like "editable dream"
  #  end
  #
  #  context "get edit for others dream" do
  #    before(:each) { get :edit, id: create(:owned_dream) }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #
  #  context "patch update for own dream with valid parameters" do
  #    let(:dream) { create(:dream, user: user) }
  #
  #    it_should_behave_like "successful dream update"
  #  end
  #
  #  context "patch update for own dream with invalid parameters" do
  #    let(:dream) { create(:dream, user: user) }
  #    let(:action) { lambda { patch :update, id: dream, dream: {body: ' '} } }
  #
  #    it "assigns dream to @entry" do
  #      action.call
  #      expect(assigns[:entry]).to eq(dream)
  #    end
  #
  #    it "leaves dream intact" do
  #      expect(action).not_to change(dream, :body)
  #    end
  #
  #    it "renders dreams/edit" do
  #      action.call
  #      expect(response).to render_template('dreams/edit')
  #    end
  #  end
  #
  #  context "patch update for others dream" do
  #    before(:each) { patch :update, id: create(:owned_dream) }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #
  #  context "patch update for anonymous dream" do
  #    before(:each) { patch :update, id: create(:dream) }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #
  #  context "delete destroy for own dream" do
  #    let!(:dream) { create(:dream, user: user) }
  #
  #    it_should_behave_like "successful dream deletion"
  #  end
  #
  #  context "delete destroy for others protected dream" do
  #    before(:each) { delete :destroy, id: create(:owned_dream) }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #
  #  context "delete destroy for others private dream" do
  #    before(:each) { delete :destroy, id: create(:private_dream) }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #
  #  context "delete destroy for anonymous dream" do
  #    before(:each) { delete :destroy, id: create(:dream) }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #end
  #
  #context "moderator" do
  #  before(:each) { session[:user_id] = create(:moderator).id }
  #
  #  context "get edit for public dream" do
  #    let(:dream) { create(:dream) }
  #
  #    it_should_behave_like "editable dream"
  #  end
  #
  #  context "get edit for others protected dream" do
  #    let(:dream) { create(:protected_dream) }
  #
  #    it_should_behave_like "editable dream"
  #  end
  #
  #  context "get edit for others private dream" do
  #    let(:dream) { create(:private_dream) }
  #    before(:each) { get :edit, id: dream }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #
  #  context "patch update for public dream" do
  #    let(:dream) { create(:dream) }
  #
  #    it_should_behave_like "successful dream update"
  #  end
  #
  #  context "patch update for protected dream" do
  #    let(:dream) { create(:protected_dream) }
  #
  #    it_should_behave_like "successful dream update"
  #  end
  #
  #  context "patch update for private dream" do
  #    let(:dream) { create(:private_dream) }
  #    before(:each) { patch :update, id: dream }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #
  #  context "delete destroy for others public dream" do
  #    let!(:dream) { create(:dream) }
  #
  #    it_should_behave_like "successful dream deletion"
  #  end
  #
  #  context "delete destroy for others protected dream" do
  #    let!(:dream) { create(:protected_dream) }
  #
  #    it_should_behave_like "successful dream deletion"
  #  end
  #
  #  context "delete destroy for others private dream" do
  #    let(:dream) { create(:private_dream) }
  #    before(:each) { delete :destroy, id: dream }
  #
  #    it_should_behave_like "restricted access"
  #  end
  #end
  #
  #context "getting tagged dreams" do
  #  let(:dream) { create(:dream) }
  #  let!(:entry_tag) { create(:dream_tag) }
  #
  #  it "assigns dreams with given tag to @entries" do
  #    dream.tags << entry_tag
  #    get :tagged, tag: entry_tag.name
  #    expect(assigns[:entries]).to include(dream)
  #  end
  #
  #  it "doesn't assign dreams without given tag to @entries" do
  #    dream.tags << create(:dream_tag, name: 'Не входит')
  #    get :tagged, tag: entry_tag.name
  #    expect(assigns[:entries]).not_to include(dream)
  #  end
  #end
  #
  #context "getting random dream" do
  #  before(:each) do
  #    create(:dream)
  #    get :random
  #  end
  #
  #  it "assigns random dream to @entry" do
  #    expect(assigns[:entry]).to be_a(Entry::Dream)
  #  end
  #
  #  it "renders dreams/random" do
  #    expect(response).to render_template('dreams/random')
  #  end
  #end
  #
  #context "getting dreams of user" do
  #  let!(:public_dream) { create(:dream, user: user) }
  #  let!(:protected_dream) { create(:protected_dream, user: user) }
  #  let!(:private_dream) { create(:private_dream, user: user) }
  #  let!(:other_dream) { create(:dream) }
  #
  #  shared_examples "common visible dreams" do
  #    it "has public dream in @entries" do
  #      expect(assigns[:entries]).to include(public_dream)
  #    end
  #
  #    it "hasn't private dream in @entries" do
  #      expect(assigns[:entries]).not_to include(private_dream)
  #    end
  #
  #    it "hasn't other dream in @entries" do
  #      expect(assigns[:entries]).not_to include(other_dream)
  #    end
  #
  #    it "renders dreams/dreams_of_user" do
  #      expect(response).to render_template('dreams/dreams_of_user')
  #    end
  #  end
  #
  #  context "anonymous user" do
  #    before(:each) do
  #      session[:user_id] = nil
  #      get :dreams_of_user, login: user.login
  #    end
  #
  #    it_should_behave_like "common visible dreams"
  #
  #    it "hasn't protected dream in @entries" do
  #      expect(assigns[:entries]).not_to include(protected_dream)
  #    end
  #  end
  #
  #  context "loogged in user" do
  #    before(:each) do
  #      session[:user_id] = create(:user).id
  #      get :dreams_of_user, login: user.login
  #    end
  #
  #    it_should_behave_like "common visible dreams"
  #
  #    it "has protected dream in @entries" do
  #      expect(assigns[:entries]).to include(protected_dream)
  #    end
  #  end
  #end
end
