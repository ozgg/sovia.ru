require 'spec_helper'

describe "dreams/show.html.erb" do
  it "renders dream" do
    dream = create(:dream, title: 'Some dream')
    assign(:dream, dream)
    render
    expect(rendered).to contain(dream.title)
  end
end
