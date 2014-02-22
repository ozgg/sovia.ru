require 'spec_helper'

describe StatisticsController do
  context "get index" do
    before(:each) { get :index }

    it "renders statistics/index" do
      expect(response).to render_template('statistics/index')
    end
  end

  context "get symbols" do
    let!(:tag) { create(:dream_tag) }
    before(:each) { get :symbols }

    it "assigns entry tags to @tags" do
      expect(assigns[:dream_tags]).to include(tag)
    end

    it "renders statistics/symbols" do
      expect(response).to render_template('statistics/symbols')
    end
  end
end