require 'spec_helper'

describe IndexController do
  context "get index" do
    it "renders index/index" do
      pending
      get :index
      expect(response).to render_template('index/index')
    end

    it "assigns recent articles to @posts" do
      pending
      article = create(:article)
      get :index
      expect(assigns[:posts]).to include(article)
    end

    it "assigns recent dreams to @posts" do
      pending
      dream = create(:dream)
      get :index
      expect(assigns[:posts]).to include(dream)
    end

    it "assigns recent community posts to @posts" do
      pending
      community_post = create(:post)
      get :index
      expect(assigns[:posts]).to include(community_post)
    end
  end
end
