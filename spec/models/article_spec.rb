require 'spec_helper'

describe Article do
  context "after initialization" do
    let(:article) { Article.new }

    it "sets type to article" do
      pending
      expect(article.entry_type).to eq(Article::TYPE_ARTICLE)
    end

    it "sets privacy to none" do
      pending
      expect(article.privacy).to eq(Article::PRIVACY_NONE)
    end
  end

  context "when initialized" do
    let(:article) { build(:article) }

    it "is valid with valid attributes" do
      pending
      expect(article).to be_valid
    end

    it "is invalid without user" do
      pending
      article.user = nil
      expect(article).not_to be_valid
    end

    it "is invalid without title" do
      pending
      article.title = ' '
      expect(article).not_to be_valid
    end
  end
end