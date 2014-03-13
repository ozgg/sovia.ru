require 'spec_helper'

describe "dreambook/word.html.erb" do
  let(:tag) { create(:dream_tag) }

  it "renders dreambook/letters" do
    assign(:letters, [])
    assign(:tag, tag)
    render
    expect(rendered).to render_template('dreambook/_letters')
  end

  it "renders word description" do
    assign(:letters, [tag.letter])
    assign(:tag, tag)
    render
    expect(rendered).to contain(tag.name)
    expect(rendered).to contain(tag.description)
  end
end
