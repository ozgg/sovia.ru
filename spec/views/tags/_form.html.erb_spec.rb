require 'spec_helper'

describe "tags/_form.html.erb" do
  it "renders tag form" do
    pending
    assign(:tag, Tag::Dream.new)
    render
    form_parameters = {
        method: 'post',
        action: tags_path
    }
    expect(rendered).to have_selector('form', form_parameters) do |form|
      expect(form).to have_selector('input', name: 'tag_dream[name]', type: 'text')
      expect(form).to have_selector('textarea', name: 'tag_dream[description]')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end
