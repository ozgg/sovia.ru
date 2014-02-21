require 'spec_helper'

describe "tags/edit.html.erb" do
  it "renders tag form" do
    pending
    assign(:tag, create(:dream_tag))
    render
    expect(rendered).to render_template('tags/_form')
  end
end
