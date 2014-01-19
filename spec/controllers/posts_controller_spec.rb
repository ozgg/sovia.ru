require 'spec_helper'

describe PostsController do
  let!(:user) { create(:user) }
  let!(:entry) { create(:post, user: user, body: 'Эталон') }

  shared_examples "visible posts" do
    context "get index" do
      before(:each) { get :index }

      it "assigns posts to @posts" do
        expect(assigns[:posts]).to include(entry)
      end

      it "renders posts/index" do
        expect(response).to render_template('posts/index')
      end
    end

    context "get show" do
      before(:each) { get :show, id: entry }

      it "assigns post to @post" do
        expect(assigns[:post]).to eq(entry)
      end

      it "renders posts/show" do
        expect(response).to render_template('posts/show')
      end
    end

    context "when id is not post id" do
      it "raises record_not_found" do
        article = create(:article)
        expect { get :show, id: article.id }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  shared_examples "restricted area" do
    it "raises unauthorized exception" do
      expect(action).to raise_error(ApplicationController::UnauthorizedException)
    end
  end

  shared_examples "editable post" do
    context "get edit" do
      before(:each) { get :edit, id: entry }

      it "assigns post to @post" do
        expect(assigns[:post]).to eq(entry)
      end

      it "renders posts/edit" do
        expect(response).to render_template('posts/edit')
      end
    end

    context "patch update with valid parameters" do
      before(:each) { patch :update, id: entry, post: { body: 'Lalala' } }

      it "assigns post to @post" do
        expect(assigns[:post]).to eq(entry)
      end

      it "updates post data" do
        entry.reload
        expect(entry.body).to eq('Lalala')
      end

      it "redirects to post page" do
        expect(response).to redirect_to(entry)
      end

      it "adds flash message #{I18n.t('post.updated')}" do
        expect(flash[:message]).to eq(I18n.t('post.updated'))
      end
    end

    context "patch update with invalid parameters" do
      before(:each) { patch :update, id: entry, post: { body: ' ' } }

      it "assigns post to @post" do
        expect(assigns[:post]).to eq(entry)
      end

      it "leaves post intact" do
        entry.reload
        expect(entry.body).to eq('Эталон')
      end

      it "renders posts/edit" do
        expect(response).to render_template('posts/edit')
      end
    end

    context "delete destroy" do
      let(:action) { lambda { delete :destroy, id: entry } }

      it "assigns post to @post" do
        action.call
        expect(assigns[:post]).to eq(entry)
      end

      it "destroys post" do
        expect(action).to change(Post, :count).by(-1)
      end

      it "redirects to posts path" do
        action.call
        expect(response).to redirect_to(posts_path)
      end

      it "adds flash message #{I18n.t('post.deleted')}" do
        action.call
        expect(flash[:message]).to eq(I18n.t('post.deleted'))
      end
    end
  end

  context "for anonymous user" do
    before(:each) { session[:user_id] = nil }

    context "get new" do
      let(:action) { -> { get :new } }

      it_should_behave_like "restricted area"
    end

    context "get edit" do
      let(:action) { -> { get :edit, id: entry } }

      it_should_behave_like "restricted area"
    end

    context "post create" do
      let(:action) { -> { post :create, post: attributes_for(:post) } }

      it_should_behave_like "restricted area"
    end

    context "patch update" do
      let(:action) { -> { patch :update, id: entry } }

      it_should_behave_like "restricted area"
    end

    context "delete destroy" do
      let(:action) { -> { delete :destroy, id: entry } }

      it_should_behave_like "restricted area"
    end

    it_should_behave_like "visible posts"
  end

  context "for registered user" do
    before(:each) { session[:user_id] = user.id }

    context "get new" do
      before(:each) { get :new }

      it "assigns new post to @post" do
        expect(assigns[:post]).to be_a_new(Post)
      end

      it "renders posts/new" do
        expect(response).to render_template('posts/new')
      end
    end

    context "post create with valid parameters" do
      let(:action) { -> { post :create, post: attributes_for(:post) } }

      it "assigns post to @post" do
        action.call
        expect(assigns[:post]).to be_a(Post)
      end

      it "creates post in database" do
        expect(action).to change(Post, :count).by(1)
      end

      it "redirects to post path" do
        action.call
        expect(response).to redirect_to(Post.last)
      end

      it "adds flash message #{I18n.t('post.added')}" do
        action.call
        expect(flash[:message]).to eq(I18n.t('post.added'))
      end
    end

    context "post create with invalid parameters" do
      let(:action) { -> { post :create, post: { body: ' ' } } }

      it "assigns post to @post" do
        action.call
        expect(assigns[:post]).to be_a(Post)
      end

      it "doesn't create post in database" do
        expect(action).not_to change(Post, :count)
      end

      it "renders posts/new" do
        action.call
        expect(response).to render_template('posts/new')
      end
    end

    context "get edit for others post" do
      let(:action) { -> { get :edit, id: create(:post) } }

      it_should_behave_like "restricted area"
    end

    context "patch update for others post" do
      let(:action) { -> { patch :update, id: create(:post) }}

      it_should_behave_like "restricted area"
    end

    context "delete destroy for others post" do
      let(:action) { -> { delete :destroy, id: create(:post) }}

      it_should_behave_like "restricted area"
    end

    it_should_behave_like "visible posts"
    it_should_behave_like "editable post"
  end

  context "for moderator" do
    before(:each) { session[:user_id] = create(:moderator).id }

    it_should_behave_like "editable post"
  end
end
