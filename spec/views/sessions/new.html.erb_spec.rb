require 'spec_helper'

describe 'sessions/new.html.erb' do
  before(:each) { render }

  it 'displays form with login and password field' do
    form_parameters = {
      method: 'post',
      action: login_path
    }
    expect(rendered).to have_selector('form', form_parameters) do |form|
      expect(form).to have_selector('input', name: 'login', type: 'text')
      expect(form).to have_selector('input', name: 'password', type: 'password')
      expect(form).to have_selector('button', type: 'submit')
    end
  end

  it "displays link to password recovery form" do
    expect(rendered).to have_selector('a', href: my_recovery_path)
  end
end
