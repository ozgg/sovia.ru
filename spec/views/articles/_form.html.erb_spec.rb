require 'spec_helper'

describe "articles/_form.html.erb" do
  it "renders article form" do
    assign(:entry, Entry::Article.new)
    render
    form_parameters = {
        method: 'post',
        action: entry_articles_path
    }
    expect(rendered).to have_selector('form', form_parameters) do |form|
      expect(form).to have_selector('input', name: 'entry_article[title]', type: 'text')
      expect(form).to have_selector('textarea', name: 'entry_article[body]')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end
