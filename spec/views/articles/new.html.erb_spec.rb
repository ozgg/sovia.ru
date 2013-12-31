require 'spec_helper'

describe "articles/new.html.erb" do
  it "renders new article form" do
    assign(:article, Article.new)
    render
    expect(rendered).to render_template('articles/_form')
  end
end
