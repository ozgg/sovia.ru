require 'spec_helper'

describe 'users/recover.html.erb' do
  before(:each) { render }

  it "renders recovery form" do
    form_parameters = { method: 'post', action: code_users_path }
    expect(rendered).to have_selector('form', form_parameters) do |form|
      expect(form).to have_selector('input', type: 'email', name: 'email')
      expect(form).to have_selector('input', type: 'text', name: 'code')
      expect(form).to have_selector('input', type: 'password', name: 'user[password]')
      expect(form).to have_selector('input', type: 'password', name: 'user[password_confirmation]')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end