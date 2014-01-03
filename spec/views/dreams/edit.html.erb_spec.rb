require 'spec_helper'

describe "dreams/edit.html.erb" do
  it "renders dream form" do
    assign(:dream, create(:dream))
    render
    expect(rendered).to render_template('dreams/_form')
  end
end
