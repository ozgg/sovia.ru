require 'spec_helper'

describe "posts/show.html.erb" do
  it "renders post" do
    view.stub(:current_user)
    assign(:entry, create(:post))
    render
    expect(rendered).to render_template('entries/_entry')
  end
end
