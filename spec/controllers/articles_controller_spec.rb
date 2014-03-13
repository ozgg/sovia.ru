require 'spec_helper'

describe ArticlesController do
  let!(:article) { create(:article, title: 'Эталон', body: 'Статья') }

  shared_examples "article assigner" do
    it "assigns article to @entry" do
      expect(assigns[:entry]).to eq(article)
    end
  end

  shared_examples "article redirector" do
    it "redirects to article path" do
      expect(response).to redirect_to(verbose_entry_articles_path(id: article.id, uri_title: article.url_title))
    end
  end

  shared_examples "restricted management" do
    let(:article) { create(:article) }

    it "raises error for articles management" do
      expect { get :new }.to raise_error(ApplicationController::UnauthorizedException)
      expect { post :create }.to raise_error(ApplicationController::UnauthorizedException)
      expect { get :edit, id: article }.to raise_error(ApplicationController::UnauthorizedException)
      expect { patch :update, id: article }.to raise_error(ApplicationController::UnauthorizedException)
      expect { delete :destroy, id: article }.to raise_error(ApplicationController::UnauthorizedException)
    end
  end

  shared_examples "visible articles" do
    context "get index" do
      before(:each) { get :index }

      it "assigns articles list to @entries" do
        expect(assigns[:entries]).to include(article)
      end

      it "renders articles/index" do
        expect(response).to render_template('articles/index')
      end
    end

    context "get show" do
      before(:each) { get :show, id: article }

      it "renders articles/show" do
        expect(response).to render_template('articles/show')
      end

      it_should_behave_like "article assigner"
    end
  end

  context "when current user is anonymous" do
    before(:each) { session[:user_id] = nil }

    it_should_behave_like "visible articles"
    it_should_behave_like "restricted management"
  end

  context "when current user is not editor" do
    before(:each) { session[:user_id] = create(:user).id }

    it_should_behave_like "visible articles"
    it_should_behave_like "restricted management"
  end

  context "when current user is editor" do
    before(:each) { session[:user_id] = create(:editor).id }

    it_should_behave_like "visible articles"

    context "get new" do
      before(:each) { get :new }

      it "renders articles/new" do
        expect(response).to render_template('articles/new')
      end

      it "assigns new article to @entry" do
        expect(assigns[:entry]).to be_a_new(Entry::Article)
      end
    end

    context "post create with valid parameters" do
      before(:each) { post :create, entry_article: { title: 'a', body: 'b' } }

      it "assigns a new article to @entry" do
        expect(assigns[:entry]).to be_an(Entry::Article)
      end

      it "creates a new article" do
        expect(assigns[:entry]).to be_persisted
      end

      it "adds flash notice #{I18n.t('entry.article.created')}" do
        expect(flash[:notice]).to eq(I18n.t('entry.article.created'))
      end

      it "redirects to created article" do
        entry = Entry::Article.last
        expect(response).to redirect_to(verbose_entry_articles_path(id: entry.id, uri_title: entry.url_title))
      end
    end

    context "post create with invalid parameters" do
      before(:each) { post :create, entry_article: { title: ' ', body: ' ' } }

      it "assigns a new article to @entry" do
        expect(assigns[:entry]).to be_an(Entry::Article)
      end

      it "leaves entries table intact" do
        expect(assigns[:entry]).not_to be_persisted
      end

      it "renders articles/new" do
        expect(response).to render_template('articles/new')
      end
    end

    context "get edit" do
      before(:each) { get :edit, id: article }

      it "renders articles/edit" do
        expect(response).to render_template('articles/edit')
      end

      it_should_behave_like "article assigner"
    end

    context "patch update with valid parameters" do
      before(:each) do
        patch :update, id: article, entry_article: { title: 'a', body: 'b' }
        article.reload
      end

      it "updates article" do
        expect(article.title).to eq('a')
      end

      it "adds flash notice #{I18n.t('entry.article.updated')}" do
        expect(flash[:notice]).to eq(I18n.t('entry.article.updated'))
      end

      it_should_behave_like "article assigner"
      it_should_behave_like "article redirector"
    end

    context "patch update with invalid parameters" do
      before(:each) { patch :update, id: article, entry_article: { title: ' ', body: ' ' } }

      it "leaves article intact" do
        article.reload
        expect(article.title).to eq('Эталон')
        expect(article.body).to eq('Статья')
      end

      it "renders articles/edit" do
        expect(response).to render_template('articles/edit')
      end

      it_should_behave_like "article assigner"
    end

    context "delete destroy" do
      let(:action) { -> { delete :destroy, id: article } }

      it "removes article from database" do
        expect(action).to change(Entry::Article, :count).by(-1)
      end

      it "adds flash notice #{I18n.t('entry.article.deleted')}" do
        action.call
        expect(flash[:notice]).to eq(I18n.t('entry.article.deleted'))
      end
    end
  end
end