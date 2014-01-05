require 'spec_helper'

describe "index/index.html.erb" do
  context "when articles present" do
    it "renders articles" do
      article = create(:article)
      assign(:articles, Post.articles.order('id desc').first(3))
      render
      expect(rendered).to contain(article.title)
    end
  end

  context "when no articles present" do
    it "renders message 'Статей нет'" do
      assign(:articles, Post.articles.order('id desc').first(3))
      render
      expect(rendered).to contain(I18n.t('index.index.no_articles'))
    end
  end
end
