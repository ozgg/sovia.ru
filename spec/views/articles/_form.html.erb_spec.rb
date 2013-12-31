require 'spec_helper'

describe "articles/_form.html.erb" do
  it "renders article form" do
    assign(:article, Article.new)
    render
    form_parameters = {
        method: 'post',
        action: articles_path
    }
    expect(rendered).to have_selector('form', form_parameters) do |form|
      expect(form).to have_selector('input', name: 'article[title]', type: 'text')
      expect(form).to have_selector('textarea', name: 'article[body]')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end
