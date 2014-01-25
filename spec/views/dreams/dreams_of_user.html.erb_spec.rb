require 'spec_helper'

describe 'dreams/dreams_of_user.html.erb' do
  it "renders posts/list" do
    assign(:dreams, [])
    render
    expect(rendered).to render_template('posts/_list')
  end
end