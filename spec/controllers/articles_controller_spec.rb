require 'spec_helper'

describe ArticlesController do
  let!(:article) { create(:article, body: 'Эталон') }
  let(:user) { create(:user) }

  shared_examples "restricted area" do
    it "refuses to render new article form" do
      get :new
      expect(response).to redirect_to(root_path)
    end

    it "refuses to render existing article form" do
      get :edit, id: article
      expect(response).to redirect_to(root_path)
    end

    it "refuses to update article" do
      patch :update, id: article
      expect(response).to redirect_to(root_path)
    end

    it "refuses to delete article" do
      delete :destroy, id: article
      expect(response).to redirect_to(root_path)
    end
  end

  context "get index" do
    before(:each) { get :index }

    it "renders articles/index" do
      expect(response).to render_template('articles/index')
    end

    it "assigns articles page to @articles" do
      expect(assigns[:articles]).to include(article)
    end
  end

  context "get new" do
    before(:each) do
      session[:user_id] = user.id
      get :new
    end

    it "assigns new article to @article" do
      expect(assigns[:article]).to be_a(Article)
    end

    it "renders articles/new" do
      expect(response).to render_template('articles/new')
    end
  end

  context "post create with valid parameters" do
    let(:action) { lambda { post :create, article: attributes_for(:article) } }
    before(:each) { session[:user_id] = user.id }

    it "assigns article to @article" do
      action.call
      expect(assigns[:article]).to be_article
    end

    it "creates new article" do
      expect(action).to change(Post, :count).by(1)
    end

    it "adds flash message 'Статья добавлена'" do
      action.call
      expect(flash[:message]).to eq(I18n.t('article.added'))
    end

    it "redirects to article page" do
      action.call
      expect(response).to redirect_to(article_path(Post.last))
    end
  end

  context "post create with invalid parameters" do
    let(:action) { lambda { post :create, article: { title: ' ', body: ' ' } } }
    before(:each) { session[:user_id] = user.id }

    it "assigns article to @article" do
      action.call
      expect(assigns[:article]).to be_article
    end

    it "leaves Articles intact" do
      expect(action).not_to change(Post, :count)
    end

    it "leaves flash message empty" do
      action.call
      expect(flash[:message]).to be_nil
    end

    it "renders articles/new" do
      action.call
      expect(response).to render_template('articles/new')
    end
  end

  context "get show for article" do
    before(:each) { get :show, id: article }

    it "assigns article to @article" do
      expect(assigns[:article]).to eq(article)
    end

    it "renders article/show" do
      expect(response).to render_template('articles/show')
    end
  end

  context "get show for non-article" do
    let(:dream) { create(:dream) }

    it "raises RecordNotFound for dream" do
      expect { get :show, id: dream.id }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "get edit" do
    before(:each) do
      session[:user_id] = user.id
      get :edit, id: article
    end

    it "assigns article to @article" do
      expect(assigns[:article]).to eq(article)
    end

    it "renders article/edit" do
      expect(response).to render_template('articles/edit')
    end
  end

  context "patch update with valid parameters" do
    before(:each) do
      session[:user_id] = user.id
      patch :update, id: article, article: { title: 'New title' }
    end

    it "assigns article to @article" do
      expect(assigns[:article]).to eq(article)
    end

    it "updates article" do
      article.reload
      expect(article.title).to eq('New title')
    end

    it "adds flash message 'Статья обновлена'" do
      expect(flash[:message]).to eq(I18n.t('article.updated'))
    end

    it "redirects to article page" do
      expect(response).to redirect_to(article_path(article))
    end
  end

  context "patch update with invalid parameters" do
    before(:each) do
      session[:user_id] = user.id
      patch :update, id: article, article: { body: ' ' }
    end

    it "assigns article to @article" do
      expect(assigns[:article]).to eq(article)
    end

    it "leaves article intact" do
      article.reload
      expect(article.body).to eq('Эталон')
    end

    it "renders article/edit" do
      expect(response).to render_template('articles/edit')
    end
  end

  context "delete destroy" do
    let(:action) { lambda { delete :destroy, id: article } }
    before(:each) { session[:user_id] = user.id }

    it "deletes article" do
      expect(action).to change(Post, :count).by(-1)
    end

    it "adds flash message 'Статья удалена'" do
      action.call
      expect(flash[:message]).to eq(I18n.t('article.deleted'))
    end

    it "redirects to articles list" do
      action.call
      expect(response).to redirect_to(articles_path)
    end
  end

  context "anonymous user" do
    before(:each) { session[:user_id] = nil }

    it_should_behave_like "restricted area"
  end
end