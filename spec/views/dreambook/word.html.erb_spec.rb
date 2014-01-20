require 'spec_helper'

describe "dreambook/word.html.erb" do
  let(:word) { create(:entry_tag) }

  it "renders dreambook/letters" do
    assign(:letters, [])
    assign(:tag, word)
    render
    expect(rendered).to render_template('dreambook/_letters')
  end

  it "renders word description" do
    assign(:letters, [word.letter])
    assign(:tag, word)
    render
    expect(rendered).to contain(word.name)
    expect(rendered).to contain(word.parsed_description)
  end
end
