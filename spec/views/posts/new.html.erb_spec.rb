require 'spec_helper'

describe "posts/new.html.erb" do
  it "renders new post form" do
    assign(:post, Post.new)
    render
    expect(rendered).to render_template('posts/_form')
  end
end
