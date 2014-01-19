require 'spec_helper'

describe "posts/index.html.erb" do
  it "renders post/list" do
    assign(:posts, [])
    render
    expect(rendered).to render_template('posts/_list')
  end
end
