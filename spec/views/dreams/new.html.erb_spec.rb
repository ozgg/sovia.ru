require 'spec_helper'

describe "dreams/new.html.erb" do
  it "renders new dream form" do
    view.stub(:current_user)
    assign(:entry, Entry::Dream.new)
    render
    expect(rendered).to render_template('dreams/_form')
  end
end
