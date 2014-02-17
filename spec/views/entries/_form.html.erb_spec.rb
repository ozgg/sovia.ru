require 'spec_helper'

describe "entries/_form.html.erb" do
  it "renders entry form" do
    assign(:entry, Entry.new)
    render
    form_parameters = {
        method: 'post',
        action: entries_path
    }
    expect(rendered).to have_selector('form', form_parameters) do |form|
      expect(form).to have_selector('input', name: 'entry[title]', type: 'text')
      expect(form).to have_selector('textarea', name: 'entry[body]')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end
