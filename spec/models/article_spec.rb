require 'spec_helper'

describe Article do
  context "after initialization" do
    let(:article) { Article.new }

    it "sets type to article" do
      expect(article.entry_type).to eq(Article::TYPE_ARTICLE)
    end

    it "sets privacy to none" do
      expect(article.privacy).to eq(Article::PRIVACY_NONE)
    end
  end
end