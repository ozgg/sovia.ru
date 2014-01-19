require 'spec_helper'

describe "posts/edit.html.erb" do
  it "renders post form" do
    assign(:post, create(:post))
    render
    expect(rendered).to render_template('posts/_form')
  end
end
