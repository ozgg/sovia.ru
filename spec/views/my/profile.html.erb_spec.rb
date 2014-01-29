require 'spec_helper'

describe 'my/profile.html.erb' do
  before(:each) do
    assign :current_user, create(:user)
    render
  end

  it "renders profile form" do
    expect(rendered).to have_selector('form', action: my_profile_path, method: 'post') do |f|
      expect(f).to have_selector('input', type: 'text', name: 'profile[email]')
      expect(f).to have_selector('input', type: 'password', name: 'profile[old_password]')
      expect(f).to have_selector('input', type: 'password', name: 'profile[password]')
      expect(f).to have_selector('input', type: 'password', name: 'profile[password_confirmation]')
      expect(f).to have_selector('input', type: 'checkbox', name: 'profile[allow_mail]')
      expect(f).to have_selector('button', type: 'submit')
    end
  end
end