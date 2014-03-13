require 'spec_helper'

describe "dreambook/index.html.erb" do
  it "renders dreambook/letters" do
    assign(:letters, [])
    render
    expect(rendered).to render_template('dreambook/_letters')
  end
end
