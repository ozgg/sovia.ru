require 'spec_helper'

describe 'my/confirmation/index.html.erb' do
  context "when email is confirmed" do
    it "displays message #{I18n.t('user.email_confirmed')}"
  end

  context "when email is not confirmed" do
    it "renders confirmation form"
    it "renders #{I18n.t('confirmation.send_code')} button"
  end
end