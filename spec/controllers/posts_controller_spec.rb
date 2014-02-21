require 'spec_helper'

describe PostsController do
  let(:owner) { create(:user) }
  let(:entry) { create(:post, user: owner, body: 'Эталон') }

  shared_examples "post assigner" do
    it "assigns post to @entry" do
      expect(assigns[:entry]).to eq(entry)
    end
  end

  shared_examples "post redirector" do
    it "redirects to post path" do
      expect(response).to redirect_to(entry)
    end
  end

  shared_examples "restricted creating" do
    it "raises error for posts creation" do
      expect { get :new }.to raise_error(ApplicationController::UnauthorizedException)
      expect { post :create }.to raise_error(ApplicationController::UnauthorizedException)
    end
  end
  
  shared_examples "restricted management" do
    it "raises error for posts management" do
      expect { get :edit, id: entry }.to raise_error(ApplicationController::UnauthorizedException)
      expect { patch :update, id: entry }.to raise_error(ApplicationController::UnauthorizedException)
      expect { delete :destroy, id: entry }.to raise_error(ApplicationController::UnauthorizedException)
    end
  end

  shared_examples "restricted showing" do
    it "raises error for post showing" do
      expect { get :show, id: entry }.to raise_error(ApplicationController::UnauthorizedException)
    end
  end

  shared_examples "allowed showing" do
    context "get index" do
      before(:each) { get :index }

      it "assigns posts list to @entries" do
        expect(assigns[:entries]).to include(entry)
      end

      it "renders posts/index" do
        expect(response).to render_template('posts/index')
      end
    end

    context "get show" do
      before(:each) { get :show, id: entry }

      it "renders posts/show" do
        expect(response).to render_template('posts/show')
      end

      it_should_behave_like "post assigner"
    end
  end

  shared_examples "allowed creating" do
    context "get new" do
      before(:each) { get :new }

      it "renders posts/new" do
        expect(response).to render_template('posts/new')
      end

      it "assigns new post to @entry" do
        expect(assigns[:entry]).to be_a_new(Entry::Post)
      end
    end

    context "post create with valid parameters" do
      before(:each) { post :create, entry_post: { title: 'a', body: 'b' } }

      it "assigns a new post to @entry" do
        expect(assigns[:entry]).to be_an(Entry::Post)
      end

      it "creates a new post" do
        expect(assigns[:entry]).to be_persisted
      end

      it "adds flash notice #{I18n.t('entry.post.created')}" do
        expect(flash[:notice]).to eq(I18n.t('entry.post.created'))
      end

      it "redirects to created post" do
        expect(response).to redirect_to(Entry::Post.last)
      end
    end

    context "post create with invalid parameters" do
      before(:each) { post :create, entry_post: { title: ' ', body: ' ' } }

      it "assigns a new post to @entry" do
        expect(assigns[:entry]).to be_an(Entry::Post)
      end

      it "leaves entries table intact" do
        expect(assigns[:entry]).not_to be_persisted
      end

      it "renders posts/new" do
        expect(response).to render_template('posts/new')
      end
    end
  end
  
  shared_examples "allowed management" do
    context "get edit" do
      before(:each) { get :edit, id: entry }

      it "renders posts/edit" do
        expect(response).to render_template('posts/edit')
      end

      it_should_behave_like "post assigner"
    end

    context "patch update with valid parameters" do
      before(:each) { patch :update, id: entry, entry_post: { title: 'a', body: 'b' } }

      it "updates entry" do
        entry.reload
        expect(entry.title).to eq('a')
      end

      it "adds flash notice #{I18n.t('entry.post.updated')}" do
        expect(flash[:notice]).to eq(I18n.t('entry.post.updated'))
      end

      it_should_behave_like "post assigner"
      it_should_behave_like "post redirector"
    end

    context "patch update with invalid parameters" do
      before(:each) { patch :update, id: entry, entry_post: { body: ' ' } }

      it "leaves post intact" do
        entry.reload
        expect(entry.body).to eq('Эталон')
      end

      it "renders posts/edit" do
        expect(response).to render_template('posts/edit')
      end

      it_should_behave_like "post assigner"
    end

    context "delete destroy" do
      let(:action) { -> { delete :destroy, id: entry } }

      before(:each) { entry.valid? }

      it "removes post from database" do
        expect(action).to change(Entry::Post, :count).by(-1)
      end

      it "adds flash notice #{I18n.t('entry.post.deleted')}" do
        action.call
        expect(flash[:notice]).to eq(I18n.t('entry.post.deleted'))
      end
    end
  end

  context "when current user is anonymous" do
    before(:each) { session[:user_id] = nil }

    it_should_behave_like "allowed showing"
    it_should_behave_like "restricted creating"
    it_should_behave_like "restricted management"

    context "when post is protected" do
      let!(:entry) { create(:protected_post, user: owner)}

      it_should_behave_like "restricted showing"

      context "get index" do
        it "doesn't add protected post to @entries" do
          get :index
          expect(assigns[:entries]).not_to include(entry)
        end
      end
    end
  end

  context "when current user is not moderator or owner" do
    before(:each) { session[:user_id] = create(:user).id }

    it_should_behave_like "allowed showing"
    it_should_behave_like "restricted management"
    it_should_behave_like "allowed creating"

    context "when post is protected" do
      let(:entry) { create(:protected_post, user: owner)}

      it_should_behave_like "allowed showing"
      it_should_behave_like "restricted management"
    end
  end

  context "when current user is owner" do
    before(:each) { session[:user_id] = owner.id }

    it_should_behave_like "allowed showing"
    it_should_behave_like "allowed creating"
    it_should_behave_like "allowed management"

    context "when post is protected" do
      let(:entry) { create(:protected_post, user: owner, body: 'Эталон')}

      it_should_behave_like "allowed showing"
      it_should_behave_like "allowed management"
    end
  end

  context "when current user is moderator" do
    before(:each) { session[:user_id] = create(:moderator).id }

    it_should_behave_like "allowed showing"
    it_should_behave_like "allowed creating"
    it_should_behave_like "allowed management"

    context "when post is protected" do
      let(:entry) { create(:protected_post, user: owner, body: 'Эталон')}

      it_should_behave_like "allowed showing"
      it_should_behave_like "allowed management"
    end
  end
end
