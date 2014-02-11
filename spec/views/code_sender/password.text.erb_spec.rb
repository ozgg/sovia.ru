require 'spec_helper'

describe 'code_sender/password.text.erb' do
  let(:code) { create(:password_recovery) }

  before(:each) do
    assign(:code, code)
    render
  end

  it "has link to recovery page" do
    expect(rendered).to contain(recover_users_url)
  end

  it "has code to be entered" do
    expect(rendered).to contain(code.body)
  end
end