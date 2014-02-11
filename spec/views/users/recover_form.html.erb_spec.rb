require 'spec_helper'

describe 'users/recover_form.html.erb' do
  before(:each) { render }

  it "displays form with email input" do
    expect(rendered).to have_selector('form') do |form|
      expect(form).to have_selector('input', type: 'email', name: 'email')
    end
  end
end