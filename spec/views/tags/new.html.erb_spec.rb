require 'spec_helper'

describe "tags/new.html.erb" do
  it "renders new tag form" do
    assign(:tag, EntryTag.new)
    render
    expect(rendered).to render_template('tags/_form')
  end
end
