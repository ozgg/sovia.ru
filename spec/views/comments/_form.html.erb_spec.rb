require 'spec_helper'

describe 'comments/_form.html.erb' do
  it "renders comment form" do
    assign(:comment, Comment.new(entry: create(:dream)))
    render
    form_attributes = { action: comments_path }
    expect(rendered).to have_selector('form', form_attributes) do |form|
      expect(form).to have_selector('input', name: 'comment[entry_id]')
      expect(form).to have_selector('textarea', name: 'comment[body]')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end