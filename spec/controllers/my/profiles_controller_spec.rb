require 'spec_helper'

describe My::ProfilesController do
  context "when user is not logged in" do
    before(:each) do
      session[:user_id] = nil
    end

    shared_examples "login redirector" do
      it "calls :authorized_only before action" do
        expect(response).to redirect_to(login_path)
      end
    end

    context "get show" do
      before(:each) { get :show }

      it_should_behave_like "login redirector"
    end

    context "get edit" do
      before(:each) { get :edit }

      it_should_behave_like "login redirector"
    end

    context "patch update" do
      before(:each) { patch :update }

      it_should_behave_like "login redirector"
    end
  end

  context "when user is logged in" do
    let(:user) { create(:confirmed_user, allow_mail: false, email: 'noreply@example.com') }

    before(:each) { session[:user_id] = user.id }

    context "get show" do
      before(:each) { get :show }

      it "renders my/profiles/show" do
        expect(response).to render_template('my/profiles/show')
      end
    end

    context "get edit" do
      before(:each) { get :edit }

      it "renders my/profiles/edit" do
        expect(response).to render_template('my/profiles/edit')
      end
    end

    context "updating insensitive data" do
      before(:each) { patch :update, profile: { allow_mail: true } }

      it "updates profile" do
        user.reload
        expect(user).to be_allow_mail
      end

      it "adds flash notice #{I18n.t('profile.updated')}" do
        expect(flash[:notice]).to eq(I18n.t('profile.updated'))
      end

      it "redirects to profile page" do
        expect(response).to redirect_to(my_profile_path)
      end
    end

    context "updating sensitive data" do
      context "when password is invalid" do
        before(:each) { patch :update, password: '123', profile: { allow_mail: true } }

        it "adds flash notice #{I18n.t('profile.incorrect_password')}" do
          expect(flash[:notice]).to eq(I18n.t('profile.incorrect_password'))
        end

        it "leaves user intact" do
          user.reload
          expect(user.allow_mail).to be_false
        end

        it "renders editing profile page" do
          expect(response).to render_template('my/profiles/edit')
        end
      end

      context "when password is valid" do
        it "resets mail_confirmed for new email" do
          patch :update, password: 'secret', profile: { email: 'noreply@example.org' }
          user.reload
          expect(user.email).to eq('noreply@example.org')
          expect(user.mail_confirmed).to be_false
        end

        it "sets new password if it is not empty" do
          patch :update, password: 'secret', profile: { password: '123', password_confirmation: '123' }
          user.reload
          expect(user.authenticate('123')).to be_true
        end

        it "adds flash message #{I18n.t('profile.updated')}" do
          patch :update, password: 'secret', profile: { email: 'noreply@example.com' }
          expect(flash[:notice]).to eq(I18n.t('profile.updated'))
        end

        it "redirects to editing profile page" do
          patch :update, password: 'secret', profile: { email: 'noreply@example.com' }
          expect(response).to redirect_to(my_profile_path)
        end
      end
    end
  end
end
