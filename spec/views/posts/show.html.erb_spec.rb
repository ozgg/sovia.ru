require 'spec_helper'

describe "posts/show.html.erb" do
  it "renders post" do
    assign(:post, create(:post))
    render
    expect(rendered).to render_template('posts/_post')
  end
end
