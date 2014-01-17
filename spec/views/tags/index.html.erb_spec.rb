require 'spec_helper'

describe "tags/index.html.erb" do
  let(:tags) { EntryTag.order('name asc').page(1).per(5) }

  context "when tags present" do
    it "shows tags list" do
      entry_tag = create(:entry_tag)
      assign(:tags, tags)
      render
      expect(rendered).to contain(entry_tag.name)
    end
  end

  context "when no tags found" do
    it "shows message #{I18n.t('tags.list.no_tags')}" do
      assign(:tags, tags)
      render
      expect(rendered).to contain(I18n.t('tags.list.no_tags'))
    end
  end
end
