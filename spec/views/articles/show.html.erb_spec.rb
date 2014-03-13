require 'spec_helper'

describe "articles/show.html.erb" do
  it "renders article" do
    allow(view).to receive(:current_user)
    article = create(:article)
    assign(:entry, article)
    render
    expect(rendered).to contain(article.title)
  end
end
