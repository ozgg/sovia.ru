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
    context "get new" do
      it "assigns new user to @user"
      it "renders users/register"
    end

    context "post create with valid parameters" do
      it "assigns new user to @user"
      it "creates user in database"
      it "sets user_id in session to new user"
      it "redirects to root path"
    end

    context "post create with invalid parameters" do
      it "assigns new user to @user"
      it "doesn't create user in database"
      it "renders users/register"
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
  end
end