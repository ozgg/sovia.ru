require 'spec_helper'

describe My::ConfirmationsController do
  context "when user is not logged in" do
    before(:each) { session[:user_id] = nil }

    shared_examples "login redirector" do
      it "redirects to login_path" do
        expect(response).to redirect_to login_path
      end

      it "adds flash notice #{I18n.t('please_log_in')}" do
        expect(flash[:notice]).to eq(I18n.t('please_log_in'))
      end
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
        it "redirects to edit_my_profile_path" do
          expect(response).to redirect_to edit_my_profile_path
        end

        it "adds flash notice #{I18n.t('confirmation.set_email')}" do
          expect(flash[:notice]).to eq(I18n.t('confirmation.set_email'))
        end
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
      it "redirects to my_profile_path" do
        expect(response).to redirect_to(my_profile_path)
      end

      it "adds flash notice #{I18n.t('user.email_confirmed')}" do
        expect(flash[:notice]).to eq(I18n.t('user.email_confirmed'))
      end
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
      it "adds flash message #{I18n.t('user.code_invalid')}" do
        expect(flash[:notice]).to eq(I18n.t('user.code_invalid'))
      end

      it "redirects to my_confirmation_path" do
        expect(response).to redirect_to(my_confirmation_path)
      end
    end

    shared_examples "code activator" do
      it "activates code" do
        code.reload
        expect(code).to be_activated
      end
    end

    context "get show" do
      before(:each) { get :show }

      it "renders my/confirmations/show" do
        expect(response).to render_template('my/confirmations/show')
      end
    end

    context "post create" do
      before(:each) do
        allow(controller).to receive(:current_user).and_return(user)
        user.stub(:email_confirmation).and_return(create(:email_confirmation, user: user))
        post :create
      end

      it "calls user.email_confirmation" do
        expect(user).to have_received(:email_confirmation)
      end

      it "sends code to user" do
        expect(ActionMailer::Base.deliveries.last.to).to include(user.email)
      end

      it "redirects to my_confirmation_path" do
        expect(response).to redirect_to(my_confirmation_path)
      end

      it "adds flash notice #{I18n.t('email_confirmation_sent')}" do
        expect(flash[:notice]).to eq(I18n.t('email_confirmation_sent'))
      end
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
    end

    context "patch update with valid code" do
      let!(:code) { user.email_confirmation }

      before(:each) { patch :update, code: code.body }

      it_should_behave_like "code activator"

      it "sets user.mail_confirmed to true" do
        user.reload
        expect(user).to be_mail_confirmed
      end

      it "redirects to my_profile_path" do
        expect(response).to redirect_to(my_profile_path)
      end

      it "adds flash notice #{I18n.t('user.email_confirmed')}" do
        expect(flash[:notice]).to eq(I18n.t('user.email_confirmed'))
      end
    end
  end
end