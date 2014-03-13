require 'spec_helper'

describe "users/new.html.erb" do
  it "renders registration form" do
    assign(:user, User.new)
    render
    form_parameters = {
        method: 'post',
        action: users_path
    }
    expect(rendered).to have_selector('form', form_parameters) do |form|
      expect(form).to have_selector('input', name: 'user[login]', type: 'text')
      expect(form).to have_selector('input', name: 'user[email]', type: 'text')
      expect(form).to have_selector('input', name: 'user[password]', type: 'password')
      expect(form).to have_selector('input', name: 'user[password_confirmation]', type: 'password')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end
