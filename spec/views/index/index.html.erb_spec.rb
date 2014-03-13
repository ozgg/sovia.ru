require 'spec_helper'

describe "index/index.html.erb" do
  it "renders entries list" do
    view.stub(:current_user)
    assign(:entries, Entry.last(5))
    render
    expect(rendered).to render_template('entries/_list')
  end
end
