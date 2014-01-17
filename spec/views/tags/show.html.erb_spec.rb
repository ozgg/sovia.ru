require 'spec_helper'

describe "tags/show.html.erb" do
  it "renders tag" do
    entry_tag = create(:entry_tag)
    assign(:tag, entry_tag)
    render
    expect(rendered).to contain(entry_tag.name)
  end
end
