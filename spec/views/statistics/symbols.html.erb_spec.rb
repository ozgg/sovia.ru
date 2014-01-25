require 'spec_helper'

describe "statistics/symbols.html.erb" do
  context "when tags found" do
    before(:each) do
      create(:entry_tag)
      assign(:tags, EntryTag.page(1).per(20))
      render
    end

    it "renders tags list" do
      expect(rendered).to have_selector('a', href: tagged_dreams_path(tag: EntryTag.first.name))
    end
  end

  context "when no tags found" do
    before(:each) do
      assign :tags, []
      render
    end

    it "displays #{I18n.t('nothing_found')}" do
      expect(rendered).to contain(I18n.t('nothing_found'))
    end
  end
end
