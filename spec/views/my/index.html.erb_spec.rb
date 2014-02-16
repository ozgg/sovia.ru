require 'spec_helper'

describe "my/index.html.erb" do
  context "logged in user" do
    before(:each) do
      assign(:current_user, create(:confirmed_user))
      render
    end

    it "has link to user's dreams" do
      expect(rendered).to have_selector('a', href: my_dreams_path)
    end

    it "has link to editing profile" do
      expect(rendered).to have_selector('a', href: my_profile_path)
    end
  end

  context "unconfirmed user" do
    before(:each) do
      assign(:current_user, create(:unconfirmed_user))
      render
    end

    it "renders form with confirmation button" do
      expect(rendered).to have_selector('form', action: confirm_users_path, method: 'post') do |form|
        expect(form).to have_selector('button', type: 'submit')
      end
    end
  end

  context "confirmed user" do
    before(:each) do
      assign(:current_user, create(:confirmed_user))
      render
    end

    it "doesn't render form with confirmation button" do
      expect(rendered).not_to have_selector('form', action: confirm_users_path, method: 'post')
    end
  end
end
