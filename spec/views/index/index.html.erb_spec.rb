require 'spec_helper'

describe "index/index.html.erb" do
  it "renders posts list" do
    assign(:posts, Post.last(5))
    render
    expect(rendered).to render_template('posts/_list')
  end
end
