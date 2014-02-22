require 'spec_helper'

describe "admin/dream_tags/new.html.erb" do
  it "renders new tag form" do
    assign(:tag, Tag::Dream.new)
    render
    expect(rendered).to render_template('admin/dream_tags/_form')
  end
end
