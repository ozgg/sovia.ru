require 'spec_helper'

describe "articles/edit.html.erb" do
  it "renders article form" do
    assign(:article, create(:article))
    render
    expect(rendered).to render_template('articles/_form')
  end
end
