require 'spec_helper'

describe "admin/dream_tags/edit.html.erb" do
  it "renders tag form" do
    pending
    assign(:tag, create(:dream_tag))
    render
    expect(rendered).to render_template('admin/dream_tags/_form')
  end
end
