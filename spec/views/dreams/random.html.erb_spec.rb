require 'spec_helper'

describe "dreams/random.html.erb" do
  it "renders dream" do
    assign(:dream, create(:dream))
    render
    expect(rendered).to render_template('posts/_post')
  end
end
