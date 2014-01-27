require 'spec_helper'

describe MyController do
  context "anonymous user" do
    before(:each) { session[:user_id] = nil }

    shared_examples "login redirector" do
      it "redirects to login path" do
        expect(response).to redirect_to(login_path)
      end

      it "adds flash message #{I18n.t('please_log_in')}" do
        expect(flash[:message]).to eq(I18n.t('please_log_in'))
      end
    end

    context "get index" do
      before(:each) { get :index }

      it_should_behave_like "login redirector"
    end

    context "get dreams" do
      before(:each) { get :dreams }

      it_should_behave_like "login redirector"
    end

    context "get profile" do
      before(:each) { get :profile }

      it_should_behave_like "login redirector"
    end

    context "patch update_profile" do
      before(:each) { patch :profile }

      it_should_behave_like "login redirector"
    end
  end

  context "logged in user" do
    let(:user) { create(:user, mail_confirmed: true) }
    before(:each) { session[:user_id] = user.id }

    context "get index" do
      before(:each) { get :index }

      it "renders my/index" do
        expect(response).to render_template('my/index')
      end
    end

    context "get dreams" do
      it "renders my/dreams" do
        get :dreams
        expect(response).to render_template('my/dreams')
      end

      it "adds public user dreams to @dreams" do
        dream = create(:dream, user: user)
        get :dreams
        expect(assigns[:dreams]).to include(dream)
      end

      it "adds protected user dreams to @dreams" do
        dream = create(:protected_dream, user: user)
        get :dreams
        expect(assigns[:dreams]).to include(dream)
      end

      it "adds private user dreams to @dreams" do
        dream = create(:private_dream, user: user)
        get :dreams
        expect(assigns[:dreams]).to include(dream)
      end

      it "doesn't add anonymous dreams to @dreams" do
        dream = create(:dream)
        get :dreams
        expect(assigns[:dreams]).not_to include(dream)
      end

      it "doesn't add others protected dreams to @dreams" do
        dream = create(:protected_dream)
        get :dreams
        expect(assigns[:dreams]).not_to include(dream)
      end

      it "doesn't add others private dreams to @dreams" do
        dream = create(:private_dream)
        get :dreams
        expect(assigns[:dreams]).not_to include(dream)
      end
    end

    context "get profile" do
      before(:each) { get :profile }

      it "renders my/profile" do
        expect(response).to render_template('my/profile')
      end
    end

    context "patch update_profile" do
      context "changing mail flag" do
        before(:each) { patch :update_profile, profile: { allow_mail: true } }

        it "updates allow_mail flag" do
          user.reload
          expect(user.allow_mail).to be_true
        end

        it "adds flash message #{I18n.t('profile.updated')}" do
          expect(flash[:message]).to eq(I18n.t('profile.updated'))
        end

        it "redirects to profile path" do
          expect(response).to redirect_to(my_profile_path)
        end
      end

      context "changing email or password" do
        let(:new_data) { { email: 'a@example.com', password: '1234', password_confirmation: '1234' } }

        context "when original password is valid" do
          before(:each) { patch :update_profile, profile: { old_password: 'secret' }.merge(new_data) }

          it "changes email" do
            user.reload
            expect(user.email).to eq('a@example.com')
          end

          it "resets mail_confirmed flag" do
            user.reload
            expect(user.mail_confirmed).to be_false
          end

          it "changes password" do
            old_digest = user.password_digest
            user.reload
            expect(user.password_digest).not_to eq(old_digest)
          end

          it "redirects to profile page" do
            expect(response).to redirect_to(my_profile_path)
          end
        end

        context "when original password is invalid" do
          before(:each) { patch :update_profile, profile: { old_password: '123' }.merge(new_data) }

          it "adds flash message #{I18n.t('profile.incorrect_password')}" do
            expect(flash[:message]).to eq(I18n.t('profile.incorrect_password'))
          end

          it "leaves email intact" do
            user.reload
            expect(user.email).not_to eq(new_data[:email])
          end

          it "leaves password intact" do
            old_hash = user.password_digest
            user.reload
            expect(user.password_digest).to eq(old_hash)
          end

          it "redirects to profile path" do
            expect(response).to redirect_to(my_profile_path)
          end
        end
      end
    end
  end
end
