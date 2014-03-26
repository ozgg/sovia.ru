require 'spec_helper'

describe ThoughtsController do
  let(:owner) { create(:user) }
  let(:entry) { create(:thought, user: owner, body: 'Эталон') }

  shared_examples "thought assigner" do
    it "assigns thought to @entry" do
      expect(assigns[:entry]).to eq(entry)
    end
  end

  shared_examples "thought redirector" do
    it "redirects to thgought path" do
      expect(response).to redirect_to(verbose_entry_thoughts_path(id: entry.id, uri_title: entry.url_title))
    end
  end

  shared_examples "restricted creating" do
    it "raises error for thoughts creation" do
      expect { get :new }.to raise_error(ApplicationController::UnauthorizedException)
      expect { post :create }.to raise_error(ApplicationController::UnauthorizedException)
    end
  end
  
  shared_examples "restricted management" do
    it "raises error for thoughts management" do
      expect { get :edit, id: entry }.to raise_error(ApplicationController::UnauthorizedException)
      expect { patch :update, id: entry }.to raise_error(ApplicationController::UnauthorizedException)
      expect { delete :destroy, id: entry }.to raise_error(ApplicationController::UnauthorizedException)
    end
  end

  shared_examples "restricted showing" do
    it "raises error for thought showing" do
      expect { get :show, id: entry }.to raise_error(ApplicationController::UnauthorizedException)
    end
  end

  shared_examples "allowed showing" do
    context "get index" do
      let!(:private_entry) { create(:private_thought) }
      before(:each) { get :index }

      it "assigns thoughts list to @entries" do
        expect(assigns[:entries]).to include(entry)
      end

      it "doesn't include private thought to @entries" do
        expect(assigns[:entries]).not_to include(private_entry)
      end

      it "renders thoughts/index" do
        expect(response).to render_template('thoughts/index')
      end
    end

    context "get show" do
      before(:each) { get :show, id: entry }

      it "renders thoughts/show" do
        expect(response).to render_template('thoughts/show')
      end

      it_should_behave_like "thought assigner"
    end
  end

  shared_examples "allowed creating" do
    context "get new" do
      before(:each) { get :new }

      it "renders thoughts/new" do
        expect(response).to render_template('thoughts/new')
      end

      it "assigns new thought to @entry" do
        expect(assigns[:entry]).to be_a_new(Entry::Thought)
      end
    end

    context "post create with valid parameters" do
      before(:each) do
        allow(controller).to receive(:'suspect_spam?')
        post :create, entry_thought: { title: 'a', body: 'b' }
      end

      it "assigns a new thought to @entry" do
        expect(assigns[:entry]).to be_an(Entry::Thought)
      end

      it "creates a new thought" do
        expect(assigns[:entry]).to be_persisted
      end

      it "adds flash notice #{I18n.t('entry.thought.created')}" do
        expect(flash[:notice]).to eq(I18n.t('entry.thought.created'))
      end

      it "redirects to created thought" do
        entry = Entry::Thought.last
        expect(response).to redirect_to(verbose_entry_thoughts_path(id: entry.id, uri_title: entry.url_title))
      end

      it "suspects spam" do
        expect(controller).to have_received(:'suspect_spam?')
      end
    end

    context "post create with invalid parameters" do
      before(:each) { post :create, entry_thought: { title: ' ', body: ' ' } }

      it "assigns a new thought to @entry" do
        expect(assigns[:entry]).to be_an(Entry::Thought)
      end

      it "leaves entries table intact" do
        expect(assigns[:entry]).not_to be_persisted
      end

      it "renders thoughts/new" do
        expect(response).to render_template('thoughts/new')
      end
    end
  end
  
  shared_examples "allowed management" do
    context "get edit" do
      before(:each) { get :edit, id: entry }

      it "renders thoughts/edit" do
        expect(response).to render_template('thoughts/edit')
      end

      it_should_behave_like "thought assigner"
    end

    context "patch update with valid parameters" do
      before(:each) do
        patch :update, id: entry, entry_thought: { title: 'a', body: 'b' }
        entry.reload
      end

      it "updates entry" do
        expect(entry.title).to eq('a')
      end

      it "adds flash notice #{I18n.t('entry.thought.updated')}" do
        expect(flash[:notice]).to eq(I18n.t('entry.thought.updated'))
      end

      it_should_behave_like "thought assigner"
      it_should_behave_like "thought redirector"
    end

    context "patch update with invalid parameters" do
      before(:each) { patch :update, id: entry, entry_thought: { body: ' ' } }

      it "leaves thought intact" do
        entry.reload
        expect(entry.body).to eq('Эталон')
      end

      it "renders thoughts/edit" do
        expect(response).to render_template('thoughts/edit')
      end

      it_should_behave_like "thought assigner"
    end

    context "delete destroy" do
      let(:action) { -> { delete :destroy, id: entry } }

      before(:each) { entry.valid? }

      it "removes thought from database" do
        expect(action).to change(Entry::Thought, :count).by(-1)
      end

      it "adds flash notice #{I18n.t('entry.thought.deleted')}" do
        action.call
        expect(flash[:notice]).to eq(I18n.t('entry.thought.deleted'))
      end
    end
  end

  context "when current user is anonymous" do
    before(:each) { session[:user_id] = nil }

    it_should_behave_like "allowed showing"
    it_should_behave_like "restricted creating"
    it_should_behave_like "restricted management"

    context "when thought is protected" do
      let!(:entry) { create(:protected_thought, user: owner)}

      it_should_behave_like "restricted showing"

      context "get index" do
        it "doesn't add protected thought to @entries" do
          get :index
          expect(assigns[:entries]).not_to include(entry)
        end
      end
    end

    context "when thought is private" do
      let!(:entry) { create(:private_thought, user: owner) }

      it_should_behave_like "restricted showing"
      it_should_behave_like "restricted management"
    end
  end

  context "when current user is not moderator or owner" do
    before(:each) { session[:user_id] = create(:user).id }

    it_should_behave_like "allowed showing"
    it_should_behave_like "restricted management"
    it_should_behave_like "allowed creating"

    context "when thought is protected" do
      let(:entry) { create(:protected_thought, user: owner)}

      it_should_behave_like "allowed showing"
      it_should_behave_like "restricted management"
    end

    context "when thought is private" do
      let!(:entry) { create(:private_thought, user: owner) }

      it_should_behave_like "restricted showing"
      it_should_behave_like "restricted management"
    end
  end

  context "when current user is owner" do
    before(:each) { session[:user_id] = owner.id }

    it_should_behave_like "allowed showing"
    it_should_behave_like "allowed creating"
    it_should_behave_like "allowed management"

    context "when thought is protected" do
      let(:entry) { create(:protected_thought, user: owner, body: 'Эталон')}

      it_should_behave_like "allowed showing"
      it_should_behave_like "allowed management"
    end

    context "when thought is private" do
      let(:entry) { create(:private_thought, user: owner, body: 'Эталон') }

      context "get show" do
        before(:each) { get :show, id: entry }

        it "renders thoughts/show" do
          expect(response).to render_template('thoughts/show')
        end

        it_should_behave_like "thought assigner"
      end

      it_should_behave_like "allowed management"
    end
  end

  context "when current user is moderator" do
    before(:each) { session[:user_id] = create(:moderator).id }

    it_should_behave_like "allowed showing"
    it_should_behave_like "allowed creating"
    it_should_behave_like "allowed management"

    context "when thought is protected" do
      let(:entry) { create(:protected_thought, user: owner, body: 'Эталон')}

      it_should_behave_like "allowed showing"
      it_should_behave_like "allowed management"
    end

    context "when thought is private" do
      let!(:entry) { create(:private_thought, user: owner) }

      it_should_behave_like "restricted showing"
      it_should_behave_like "restricted management"
    end
  end
end
