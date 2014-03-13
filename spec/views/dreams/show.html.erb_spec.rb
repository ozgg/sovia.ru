require 'spec_helper'

describe "dreams/show.html.erb" do
  it "renders entries/_entry" do
    view.stub(:current_user)
    dream = create(:dream, title: 'Some dream')
    assign(:entry, dream)
    render
    expect(rendered).to render_template('entries/_entry')
  end
end
