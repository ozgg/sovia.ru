require 'spec_helper'

describe Entry::Article do
  let(:article) { build(:article) }

  context "when validating" do
    it "is valid with valid attributes" do
      expect(article).to be_valid
    end

    it "is invalid without user" do
      article.user = nil
      expect(article).not_to be_valid
    end

    it "is invalid without title" do
      article.title = ' '
      expect(article).not_to be_valid
    end
  end

  context "when destroyed" do
    it "decrements entries_count for used tags" do
      tag     = create(:article_tag)
      article = create(:article)
      article.tags << tag
      expect { article.destroy }.to change(tag, :entries_count).by(-1)
    end
  end
end
