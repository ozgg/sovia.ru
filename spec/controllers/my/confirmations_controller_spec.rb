require 'spec_helper'

describe My::ConfirmationsController do
  context "when user is not logged in" do
    before(:each) { session[:user_id] = nil }

    shared_examples "login redirector" do
      it "redirects to login_path"
      it "adds flash notice #{I18n.t('please_log_in')}"
    end

    context "get show" do
      before(:each) { get :show }

      it_should_behave_like "login redirector"
    end

    context "post create" do
      before(:each) { post :create }

      it_should_behave_like "login redirector"
    end

    context "patch update" do
      before(:each) { patch :update }

      it_should_behave_like "login redirector"
    end
  end

  context "when user is logged in" do
    context "when email is not set" do
      before(:each) { session[:user_id] = create(:user).id }

      shared_examples "profile redirector" do
        it "redirects to edit_my_profile_path"
        it "adds flash notice #{I18n.t('confirmation.set_email')}"
      end

      context "get show" do
        before(:each) { get :show }

        it_should_behave_like "profile redirector"
      end

      context "post create" do
        before(:each) { post :create }

        it_should_behave_like "profile redirector"
      end

      context "patch update" do
        before(:each) { patch :update }

        it_should_behave_like "profile redirector"
      end
    end
  end

  context "when email is confirmed" do
    before(:each) { session[:user_id] = create(:confirmed_user).id }

    shared_examples "profile redirector" do
      it "redirects to my_profile_path"
      it "adds flash notice #{I18n.t('user.email_confirmed')}"
    end

    context "get show" do
      before(:each) { get :show }

      it_should_behave_like "profile redirector"
    end

    context "post create" do
      before(:each) { post :create }

      it_should_behave_like "profile redirector"
    end

    context "patch update" do
      before(:each) { patch :update }

      it_should_behave_like "profile redirector"
    end
  end

  context "when email is not confirmed" do
    let(:user) { create(:unconfirmed_user) }

    before(:each) { session[:user_id] = user.id }

    shared_examples "invalid code" do
      it "adds flash message #{I18n.t('user.code_invalid')}"
      it "redirects to my_confirmation_path"
    end

    shared_examples "code activator" do
      it "activates code"
    end

    context "get show" do
      before(:each) { get :show }

      it "renders my/confirmations/show"
    end

    context "post create" do
      before(:each) { post :create }

      it "calls user.email_confirmation"
      it "sends code to user"
      it "redirects to my_confirmation_path"
      it "adds flash notice #{I18n.t('email_confirmation_sent')}"
    end

    context "patch update with invalid email" do
      let!(:code) { user.email_confirmation }

      before(:each) do
        user.update(email: 'noreply@example.org')
        patch :update, code: code.body
      end

      it_should_behave_like "invalid code"
      it_should_behave_like "code activator"
    end

    context "patch update with invalid code" do
      let!(:code) { user.email_confirmation }

      before(:each) { patch :update, code: 'wrong' }

      it_should_behave_like "invalid code"
      it_should_behave_like "code activator"
    end

    context "patch update with valid code" do
      let!(:code) { user.email_confirmation }

      before(:each) { patch :update, code: code.body }

      it_should_behave_like "code activator"

      it "sets user.mail_confirmed to true"
      it "redirects to my_profile_path"
      it "adds flash notice #{I18n.t('user.email_confirmed')}"
    end
  end
end