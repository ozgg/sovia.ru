require 'spec_helper'

describe 'dreams/tagged.html.erb' do
  it "renders dreams/list" do
    assign(:dreams, [])
    render
    expect(rendered).to render_template('dreams/_list')
  end
end