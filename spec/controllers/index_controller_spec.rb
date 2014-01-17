require 'spec_helper'

describe IndexController do
  context "get index" do
    it "renders index/index" do
      get :index
      expect(response).to render_template('index/index')
    end

    it "assigns recent articles to @posts" do
      article = create(:article)
      get :index
      expect(assigns[:posts]).to include(article)
    end

    it "assigns recend dreams to @posts" do
      dream = create(:dream)
      get :index
      expect(assigns[:posts]).to include(dream)
    end
  end
end
