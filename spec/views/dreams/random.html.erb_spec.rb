require 'spec_helper'

describe "dreams/random.html.erb" do
  it "renders dream" do
    allow(view).to receive(:current_user)
    assign(:entry, create(:dream))
    render
    expect(rendered).to render_template('entries/_entry')
  end
end
