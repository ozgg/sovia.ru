require 'spec_helper'

describe "dreambook/word.html.erb" do
  let(:tag_dream) { create(:dream_tag) }

  before(:each) { allow(view).to receive(:current_user) }

  it "renders dreambook/letters" do
    assign(:letters, [])
    assign(:tag, tag_dream)
    render
    expect(rendered).to render_template('dreambook/_letters')
  end

  it "renders word description" do
    assign(:letters, [tag_dream.letter])
    assign(:tag, tag_dream)
    render
    expect(rendered).to contain(tag_dream.name)
    expect(rendered).to contain(tag_dream.description)
  end
end
