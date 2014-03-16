require 'spec_helper'

describe 'dreambook/_letters.html.erb' do
  context "when letters found" do
    it "renders letters list" do
      assign :letters, { r: %W(А Б) }
      render
      expect(rendered).to have_selector('a', href: url_for(dreambook_letter_path(letter: 'А')))
      expect(rendered).to have_selector('a', href: url_for(dreambook_letter_path(letter: 'Б')))
    end
  end

  context "when no letters found" do
    it "renders message #{I18n.t('nothing_found')}" do
      assign :letters, []
      render
      expect(rendered).to contain(I18n.t('nothing_found'))
    end
  end
end