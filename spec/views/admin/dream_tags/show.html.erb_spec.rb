require 'spec_helper'

describe "admin/dream_tags/show.html.erb" do
  it "renders tag" do
    tag = create(:dream_tag)
    assign(:tag, tag)
    render
    expect(rendered).to contain(tag.name)
  end
end
