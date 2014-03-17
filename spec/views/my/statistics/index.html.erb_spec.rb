require 'spec_helper'

describe "my/statistics/index.html.erb" do
  before(:each) { render }

  it "contains link to tags statistics" do
    expect(rendered).to have_selector('a', href: my_symbols_path)
  end
end
