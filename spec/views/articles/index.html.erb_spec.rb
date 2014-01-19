require 'spec_helper'

describe "articles/index.html.erb" do
  it "renders post/list" do
    assign(:articles, [])
    render
    expect(rendered).to render_template('posts/_list')
  end
end
