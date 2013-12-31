require 'spec_helper'

describe "articles/index.html.erb" do
  let(:articles) { Article.order('id desc').page(1).per(5) }

  context "when articles present" do
    it "shows articles list" do
      article = create(:article)
      assign(:articles, articles)
      render
      expect(rendered).to contain(article.title)
    end
  end

  context "when no articles found" do
    it "shows message 'Статей нет'" do
      assign(:articles, articles)
      render
      expect(rendered).to contain(I18n.t('articles.index.no_articles'))
    end
  end
end
