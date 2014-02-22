require 'spec_helper'

describe "admin/dream_tags/index.html.erb" do
  let(:dream_tags) { Tag::Dream.order('name asc').page(1).per(50) }

  context "when tags present" do
    it "shows tags list" do
      tag = create(:dream_tag)
      assign(:tags, dream_tags)
      render
      expect(rendered).to contain(tag.name)
    end
  end

  context "when no tags found" do
    it "shows message #{I18n.t('tags.list.no_tags')}" do
      assign(:tags, dream_tags)
      render
      expect(rendered).to contain(I18n.t('tags.list.no_tags'))
    end
  end
end
