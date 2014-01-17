require 'spec_helper'

describe "tags/edit.html.erb" do
  it "renders tag form" do
    assign(:tag, create(:entry_tag))
    render
    expect(rendered).to render_template('tags/_form')
  end
end
