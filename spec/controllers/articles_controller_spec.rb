require 'spec_helper'

describe ArticlesController do
  let!(:article) { create(:article, title: 'Эталон') }

  shared_examples "restricted area" do
    it "refuses to render new article form" do
      expect { get :new }.to raise_error(ApplicationController::UnauthorizedException)
    end

    it "refuses to render existing article form" do
      expect { get :edit, id: article }.to raise_error(ApplicationController::UnauthorizedException)
    end

    it "refuses to update article" do
      expect { patch :update, id: article }.to raise_error(ApplicationController::UnauthorizedException)
    end

    it "refuses to delete article" do
      expect { delete :destroy, id: article }.to raise_error(ApplicationController::UnauthorizedException)
    end
  end

  shared_examples "viewable articles list" do
    before(:each) { get :index }

    it "renders articles/index" do
      expect(response).to render_template('articles/index')
    end

    it "assigns articles page to @articles" do
      expect(assigns[:articles]).to include(article)
    end
  end

  shared_examples "viewable article" do
    before(:each) { get :show, id: article }

    it "assigns article to @article" do
      expect(assigns[:article]).to eq(article)
    end

    it "renders article/show" do
      expect(response).to render_template('articles/show')
    end

    it "raises RecordNotFound for dream" do
      dream = create(:dream)
      expect { get :show, id: dream.id }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "anonymous user" do
    before(:each) { session[:user_id] = nil }

    it_should_behave_like "restricted area"
    it_should_behave_like "viewable articles list"
    it_should_behave_like "viewable article"
  end

  context "non-editor" do
    before(:each) { session[:user_id] = create(:user).id }

    it_should_behave_like "restricted area"
    it_should_behave_like "viewable articles list"
    it_should_behave_like "viewable article"
  end

  context "editor" do
    before(:each) { session[:user_id] = create(:editor).id }

    it_should_behave_like "viewable articles list"
    it_should_behave_like "viewable article"

    context "get new" do
      before(:each) { get :new }

      it "assigns new article to @article" do
        expect(assigns[:article]).to be_a(Article)
      end

      it "renders articles/new" do
        expect(response).to render_template('articles/new')
      end
    end

    context "post create with valid parameters" do
      let(:action) { lambda { post :create, article: attributes_for(:article) } }

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

    context "get edit" do
      before(:each) { get :edit, id: article }

      it "assigns article to @article" do
        expect(assigns[:article]).to eq(article)
      end

      it "renders article/edit" do
        expect(response).to render_template('articles/edit')
      end
    end

    context "patch update with valid parameters" do
      before(:each) { patch :update, id: article, article: { title: 'New title' } }

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
      before(:each) { patch :update, id: article, article: { title: ' ' } }

      it "assigns article to @article" do
        expect(assigns[:article]).to eq(article)
      end

      it "leaves article intact" do
        article.reload
        expect(article.title).to eq('Эталон')
      end

      it "renders article/edit" do
        expect(response).to render_template('articles/edit')
      end
    end

    context "delete destroy" do
      let(:action) { lambda { delete :destroy, id: article } }

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
  end
end