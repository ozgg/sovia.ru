require 'spec_helper'

describe "tags/new.html.erb" do
  it "renders new tag form" do
    pending
    assign(:tag, Tag::Dream.new)
    render
    expect(rendered).to render_template('tags/_form')
  end
end
