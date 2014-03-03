require 'spec_helper'

describe My::RecoveriesController do
  context "when user is logged in" do
    before(:each) { session[:user_id] = create(:user).id }

    shared_examples "logged in bouncer" do
      it "redirects to root page" do
        expect(response).to redirect_to(root_path)
      end

      it "adds flash notice #{I18n.t('session.already_logged_in')}" do
        expect(flash[:notice]).to eq(I18n.t('session.already_logged_in'))
      end
    end

    context "get show" do
      before(:each) { get :show }

      it_should_behave_like "logged in bouncer"
    end

    context "post create" do
      before(:each) { post :create }

      it_should_behave_like "logged in bouncer"
    end

    context "patch update" do
      before(:each) { patch :update }

      it_should_behave_like "logged in bouncer"
    end
  end

  context "when user is not logged in" do
    let(:user) { create(:unconfirmed_user) }

    before(:each) { session[:user_id] = nil }

    context "get show" do
      before(:each) { get :show }

      it "renders my/recoveries/show" do
        expect(response).to render_template('my/recoveries/show')
      end
    end

    shared_examples "password reset" do
      it "activates code" do
        patch :update, code: code.body, user: { password: '123', password_confirmation: '123' }
        expect(code).to be_activated
      end

      it "updates user's password" do
        patch :update, code: code.body, user: { password: '123', password_confirmation: '123' }
        user.reload
        expect(user.authenticate('123')).to be_true
      end

      it "adds flash notice #{I18n.t('user.password_changed')}" do
        patch :update, code: code.body, user: { password: '123', password_confirmation: '123' }
        expect(flash[:notice]).to eq(I18n.t('user.password_changed'))
      end

      it "redirects to login page" do
        patch :update, code: code.body, user: { password: '123', password_confirmation: '123' }
        expect(response).to redirect_to(login_path)
      end
    end

    context "post create when email is found" do
      it "finds user by email" do
        expect(User).to receive(:find_by).with(email: user.email).and_return(user)
        post :create, email: user.email
      end

      it "calls user.password_recovery" do
        allow(User).to receive(:find_by).with(email: user.email).and_return(user)
        expect(user).to receive(:password_recovery)
        post :create, email: user.email
      end

      it "sends recovery code to user" do
        allow(User).to receive(:find_by).with(email: user.email).and_return(user)
        allow(user).to receive(:password_recovery).and_return(create(:password_recovery, user: user))
        post :create, email: user.email
        expect(ActionMailer::Base.deliveries.last.to).to include(user.email)
      end

      it "adds flash notice #{I18n.t('recovery_code_sent')}" do
        post :create, email: user.email
        expect(flash[:notice]).to eq(I18n.t('recovery_code_sent'))
      end

      it "redirects to my_recovery_path" do
        post :create
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context "post create when email is not found" do
      let(:email) { 'noreply@example.org' }

      it "looks for user by email" do
        expect(User).to receive(:find_by).with(email: email)
        post :create, email: email
      end

      it "adds flash notice #{I18n.t('email_not_found')}" do
        post :create, email: email
        expect(flash[:notice]).to eq(I18n.t('email_not_found'))
      end

      it "redirects to my_recovery_path" do
        post :create, email: email
        expect(response).to redirect_to(my_recovery_path)
      end
    end

    context "patch update with valid parameters" do
      let(:code) { create(:password_recovery, user: user) }

      context "when email matches payload" do
        before(:each) do
          allow(Code::Confirmation).to receive(:find_by).with(body: code.body, activated: false).and_return(code)
        end

        it_should_behave_like "password reset"

        it "sets user.mail_confirmed to true" do
          patch :update, code: code.body, user: { password: '123', password_confirmation: '123' }
          user.reload
          expect(user).to be_mail_confirmed
        end
      end

      context "when email doesn't match payload" do
        before(:each) do
          code.update(payload: 'noreply@example.org')
          allow(Code::Confirmation).to receive(:find_by).with(body: code.body, activated: false).and_return(code)
          patch :update, code: code.body, user: { password: '123', password_confirmation: '123' }
        end

        it_should_behave_like "password reset"
      end
    end

    context "patch update with invalid code" do
      before(:each) { allow(Code::Recovery).to receive(:find_by).with(body: 'wrong', activated: false) }

      it "adds flash notice #{I18n.t('user.code_invalid')}" do
        patch :update, code: 'wrong'
        expect(flash[:notice]).to eq(I18n.t('user.code_invalid'))
      end

      it "redirects to my_recovery_path" do
        patch :update, code: 'wrong'
        expect(response).to redirect_to my_recovery_path
      end
    end

    context "patch update with invalid passwords" do
      let(:code) { create(:password_recovery, user: user) }

      before(:each) do
        allow(Code::Confirmation).to receive(:find_by).with(body: code.body, activated: false).and_return(code)
        patch :update, code: code.body, user: { password: '123', password_confirmation: '321' }
      end

      it "adds flash notice #{I18n.t('user.recovery_failed')}" do
        expect(flash[:notice]).to eq(I18n.t('user.recovery_failed'))
      end

      it "leaves user intact" do
        user.reload
        expect(user.authenticate('secret')).to be_true
      end

      it "leaves code intact" do
        code.reload
        expect(code).not_to be_activated
      end

      it "redirects to my_recovery_path" do
        expect(response).to redirect_to(my_recovery_path)
      end
    end
  end
end