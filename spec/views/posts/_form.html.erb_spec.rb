require 'spec_helper'

describe "posts/_form.html.erb" do
  it "renders post form" do
    assign(:entry, Entry::Post.new)
    render
    form_parameters = {
        method: 'post',
        action: entry_posts_path
    }
    expect(rendered).to have_selector('form', form_parameters) do |form|
      expect(form).to have_selector('input', name: 'entry_post[title]', type: 'text')
      expect(form).to have_selector('textarea', name: 'entry_post[body]')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end