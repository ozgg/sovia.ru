require 'spec_helper'

describe "my/index.html.erb" do
  before(:each) { render }

  it "has link to user's dreams" do
    expect(rendered).to have_selector('a', href: my_dreams_path)
  end
end
