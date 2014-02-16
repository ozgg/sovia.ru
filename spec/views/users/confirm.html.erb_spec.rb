require 'spec_helper'

describe 'users/confirm.html.erb' do
  before(:each) { render }

  it "renders form with code field" do
    expect(rendered).to have_selector('form', method: 'post', action: code_users_path) do |form|
      expect(form).to have_selector('input', type: 'text', name: 'code')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end