require 'spec_helper'

describe "my/index/index.html.erb" do
  shared_examples "mandatory links" do
    it "has link to profile page" do
      expect(rendered).to have_selector('a', href: my_profile_path)
    end

    it "has link to user's dreams page" do
      expect(rendered).to have_selector('a', href: my_dreams_path)
    end
  end

  context "when user's email is confirmed" do
    before(:each) do
      assign(:current_user, create(:confirmed_user))
      render
    end

    it_should_behave_like "mandatory links"

    it "has no link to email confirmation page" do
      expect(rendered).not_to have_selector('a', href: my_confirmation_path)
    end
  end

  context "when user's email is not confirmed" do
    before(:each) do
      assign(:current_user, create(:user))
      render
    end

    it_should_behave_like "mandatory links"

    it "has link to email confirmation page" do
      expect(rendered).to have_selector('a', href: my_confirmation_path)
    end
  end
end
