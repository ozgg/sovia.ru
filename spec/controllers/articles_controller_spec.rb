require 'spec_helper'

describe ArticlesController do
  let!(:article) { create(:article) }

  context "anonymous user" do
    before(:each) { get :index }

    context "get index" do
      it "assigns articles list to @entries"
      it "renders articles/index"
    end

    context "get show" do
      it "assigns article to @entry"
      it "renders articles/show"
    end
  end
end