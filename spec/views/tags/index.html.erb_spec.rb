require 'spec_helper'

describe "tags/index.html.erb" do
  let(:tags) { Tag::Dream.order('name asc').page(1).per(5) }

  context "when tags present" do
    it "shows tags list" do
      pending
      tag = create(:dream_tag)
      assign(:tags, tags)
      render
      expect(rendered).to contain(tag.name)
    end
  end

  context "when no tags found" do
    it "shows message #{I18n.t('tags.list.no_tags')}" do
      pending
      assign(:tags, tags)
      render
      expect(rendered).to contain(I18n.t('tags.list.no_tags'))
    end
  end
end
