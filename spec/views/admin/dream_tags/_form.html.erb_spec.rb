require 'spec_helper'

describe "admin/dream_tags/_form.html.erb" do
  context "when @tag is new tag" do
    it "renders tag form for creating tag" do
      assign(:tag, Tag::Dream.new)
      render
      form_parameters = {
          method: 'post',
          action: admin_dream_tags_path
      }
      expect(rendered).to have_selector('form', form_parameters) do |form|
        expect(form).to have_selector('input', name: 'tag_dream[name]', type: 'text')
        expect(form).to have_selector('textarea', name: 'tag_dream[description]')
        expect(form).to have_selector('button', type: 'submit')
      end
    end
  end

  context "when @tag is existing tag" do
    it "renders form for editing tag" do
      dream_tag = create(:dream_tag)
      assign(:tag, dream_tag)
      render
      form_parameters = {
          method: 'post',
          action: admin_dream_tag_path(dream_tag)
      }
      expect(rendered).to have_selector('form', form_parameters)
    end
  end
end
