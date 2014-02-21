require 'spec_helper'

describe "dreambook/letter.html.erb" do
  context "in any case" do
    it "renders dreambook/letters" do
      assign(:letters, [])
      assign(:tags, [])
      render
      expect(rendered).to render_template('dreambook/_letters')
    end
  end

  context "when words present" do
    let!(:word) { create(:dream_tag) }

    before(:each) do
      assign(:letters, [word.letter])
      assign(:tags, Tag::Dream.where(letter: word.letter).page(1).per(50) )
      render
    end

    it "renders words list" do
      uri = url_for(dreambook_word_path(letter: word.letter, word: word.name))
      expect(rendered).to have_selector('a', href: uri)
    end
  end

  context "when no words present" do
    before(:each) do
      assign(:letters, ['А'])
      assign(:tags, [])
      render
    end

    it "renders message #{I18n.t('nothing_found')}" do
      expect(rendered).to contain(I18n.t('nothing_found'))
    end
  end
end
