require 'spec_helper'

describe "my/recoveries/show.html.erb" do
  it "renders recovery form" do
    render
    form_attributes = { action: my_recovery_path }
    expect(rendered).to have_selector('form', form_attributes) do |form|
      expect(form).to have_selector('input', type: 'hidden', name: '_method', value: 'patch')
      expect(form).to have_selector('input', type: 'text', name: 'code')
      expect(form).to have_selector('input', type: 'password', name: 'user[password]')
      expect(form).to have_selector('input', type: 'password', name: 'user[password_confirmation]')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end
