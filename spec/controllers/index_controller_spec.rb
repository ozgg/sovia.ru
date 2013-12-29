require 'spec_helper'

describe IndexController do
  context "get index" do
    it "renders index/index" do
      get :index
      expect(response).to render_template('index/index')
    end

    it "assigns recent articles to @articles" do
      article = create(:article)
      get :index
      expect(assigns[:articles]).to include(article)
    end
  end
end
