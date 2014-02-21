require 'spec_helper'

describe "tags/show.html.erb" do
  it "renders tag" do
    pending
    tag = create(:dream_tag)
    assign(:tag, tag)
    render
    expect(rendered).to contain(tag.name)
  end
end
