require 'spec_helper'

describe "my/dreams.html.erb" do
  it "renders dreams list" do
    assign(:dreams, [])
    render
    expect(rendered).to render_template('posts/_list')
  end
end
