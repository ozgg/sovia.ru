require 'spec_helper'

describe 'comments/new.html.erb' do
  it "renders comment form" do
    assign(:comment, Comment.new)
    render
    expect(rendered).to render_template('comments/_form')
  end
end