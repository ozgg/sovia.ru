require 'spec_helper'

describe "dreams/show.html.erb" do
  it "renders entries/_entry" do
    dream = create(:dream, title: 'Some dream')
    assign(:entry, dream)
    render
    expect(rendered).to render_template('entries/_entry')
  end
end
