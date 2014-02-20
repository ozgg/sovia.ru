require 'spec_helper'

describe IndexController do
  context "get index" do
    it "renders index/index" do
      get :index
      expect(response).to render_template('index/index')
    end

    it "calls Entry#recent_entries" do
      expect(Entry).to receive(:recent_entries)
      get :index
    end

    it "assigns recent entries to @entries" do
      create(:dream)
      get :index
      expect(assigns[:entries]).not_to be_empty
    end
  end
end
