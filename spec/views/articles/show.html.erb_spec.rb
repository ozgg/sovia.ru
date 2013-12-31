require 'spec_helper'

describe "articles/show.html.erb" do
  it "renders article" do
    article = create(:article)
    assign(:article, article)
    render
    expect(rendered).to contain(article.title)
  end
end
