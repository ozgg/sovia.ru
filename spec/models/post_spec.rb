require 'spec_helper'

describe Post do
  context "dream" do
    let(:dream) { build(:dream) }

    it "is valid with valid attributes" do
      expect(dream).to be_valid
    end

    it "is invalid without body" do
      dream.body = ' '
      expect(dream).not_to be_valid
    end

    it "is invalid without allowed privacy" do
      dream.privacy = 42
      expect(dream).not_to be_valid
    end
  end

  context "article" do
    before(:each) { @article = build(:article) }

    it "is valid with valid parameters" do
      expect(@article).to be_valid
    end

    it "is invalid without body" do
      @article.body = ' '
      expect(@article).not_to be_valid
    end
  end
end
