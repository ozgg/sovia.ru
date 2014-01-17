require 'spec_helper'

describe "index/index.html.erb" do
  context "when articles present" do
    it "renders articles" do
      article = create(:article)
      assign(:posts, Post.articles.order('id desc').first(3))
      render
      expect(rendered).to contain(article.title)
    end
  end

  context "when no articles present" do
    it "renders message 'Публикаций нет'" do
      assign(:posts, Post.articles.order('id desc').first(3))
      render
      expect(rendered).to contain(I18n.t('index.index.no_posts'))
    end
  end
end
