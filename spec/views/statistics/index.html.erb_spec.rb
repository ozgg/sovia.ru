require 'spec_helper'

describe "statistics/index.html.erb" do
  it "renders statistics navigation" do
    render
    expect(rendered).to have_selector('nav')
  end
end
