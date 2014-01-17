require 'spec_helper'

describe "tags/_form.html.erb" do
  it "renders tag form" do
    assign(:tag, EntryTag.new)
    render
    form_parameters = {
        method: 'post',
        action: entry_tags_path
    }
    expect(rendered).to have_selector('form', form_parameters) do |form|
      expect(form).to have_selector('input', name: 'entry_tag[name]', type: 'text')
      expect(form).to have_selector('textarea', name: 'entry_tag[description]')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end
