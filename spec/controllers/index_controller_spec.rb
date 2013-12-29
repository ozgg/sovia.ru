require 'spec_helper'

describe IndexController do
  context "get index" do
    it "renders index/index" do
      get :index
      expect(response).to render_template('index/index')
    end
  end
end
