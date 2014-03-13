require 'spec_helper'

describe 'my/confirmations/show.html.erb' do
  context "when email is confirmed" do
    before(:each) do
      allow(view).to receive(:current_user).and_return(create(:confirmed_user))
      render
    end

    it "displays message #{I18n.t('user.email_confirmed')}" do
      expect(rendered).to include(I18n.t('user.email_confirmed'))
    end

    it "doesn't display confirmation form" do
      expect(rendered).not_to have_selector('form')
    end
  end

  context "when email is not confirmed" do
    before(:each) do
      allow(view).to receive(:current_user).and_return(create(:unconfirmed_user))
      render
    end

    it "renders confirmation form" do
      expect(rendered).to have_selector('form', action: my_confirmation_path) do |form|
        expect(form).to have_selector('input', name: '_method', value: 'patch')
        expect(form).to have_selector('input', type: 'text', name: 'code')
        expect(form).to have_selector('button', type: 'submit')
      end
    end

    it "renders #{I18n.t('confirmation.send_code')} button" do
      expect(rendered).to include(I18n.t('confirmation.send_code'))
    end
  end
end