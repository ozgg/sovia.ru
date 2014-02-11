require 'spec_helper'

describe UsersController do
  shared_examples "logged in bouncer" do
    it "redirects to root path" do
      expect(response).to redirect_to(root_path)
    end

    it "adds flash message 'Вы уже вошли'" do
      expect(flash[:message]).to eq(I18n.t('session.already_logged_in'))
    end
  end

  context "anonymous user" do
    before(:each) { session[:user_id] = nil }

    context "get new" do
      before(:each) { get :new }

      it "assigns new user to @user" do
        expect(assigns[:user]).to be_a(User)
      end

      it "renders users/new" do
        expect(response).to render_template('users/new')
      end
    end

    context "post create with valid parameters" do
      let(:action) { lambda { post :create, user: attributes_for(:user) } }

      it "assigns new user to @user" do
        action.call
        expect(assigns[:user]).to be_a(User)
      end

      it "creates user in database" do
        expect(action).to change(User, :count).by(1)
      end

      it "sets user_id in session to new user" do
        action.call
        expect(session[:user_id]).to eq(User.last.id)
      end

      it "redirects to root path" do
        action.call
        expect(response).to redirect_to(root_path)
      end

      it "adds flash message 'Вы зарегистрировались и вошли'" do
        action.call
        expect(flash[:message]).to eq(I18n.t('users.create.successfully'))
      end
    end

    context "post create when bot checkbox is checked" do
      let(:action) { lambda { post :create, user: attributes_for(:user), agree: true }}

      it "doesn't add user to database" do
        expect(action).not_to change(User, :count)
      end

      it "redirects to root path" do
        action.call
        expect(response).to redirect_to(root_path)
      end

      it "adds flash message 'Вы зарегистрировались и вошли'" do
        action.call
        expect(flash[:message]).to eq(I18n.t('users.create.successfully'))
      end
    end

    context "post create with invalid parameters" do
      let(:action) { lambda { post :create, user: { login: '  ' } } }

      it "assigns new user to @user" do
        action.call
        expect(assigns[:user]).to be_a(User)
      end

      it "doesn't create user in database" do
        expect(action).not_to change(User, :count)
      end

      it "renders users/new" do
        action.call
        expect(response).to render_template('users/new')
      end
    end

    context "get recover form" do
      before(:each) { get :recover_form }

      it "renders users/recover_form" do
        expect(response).to render_template('users/recover_form')
      end
    end

    context "post recover with existing email" do
      let(:user) { create(:confirmed_user) }

      it "sends password_recovery to user object" do
        expect(User).to receive(:find_by).with(email: user.email).and_return(user)
        expect(user).to receive(:password_recovery).and_return(create(:password_recovery, user: user))
        post :send_recovery, email: user.email
      end

      it "sends code to user's email" do
        post :send_recovery, email: user.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end

      it "redirects to recover action" do
        post :send_recovery, email: user.email
        expect(response).to redirect_to(recover_users_path)
      end
    end

    context "post recover with unknown email" do
      before(:each) { post :send_recovery, email: 'non-existent@example.org' }

      it "adds flash message #{I18n.t('email_not_found')}" do
        expect(flash[:message]).to eq(I18n.t('email_not_found'))
      end

      it "redirects to password recovery form" do
        expect(response).to redirect_to(recover_form_users_path)
      end
    end
  end

  context "logged in user" do
    before(:each) { session[:user_id] = create(:user).id }

    context "get new" do
      before(:each) { get :new }

      it_should_behave_like "logged in bouncer"
    end

    context "post create" do
      before(:each) { post :create }

      it_should_behave_like "logged in bouncer"
    end

    context "get recovery_form" do
      before(:each) { get :recover_form }

      it_should_behave_like "logged in bouncer"
    end
  end
end