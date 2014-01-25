require 'spec_helper'

describe MyController do
  context "anonymous user" do
    before(:each) { session[:user_id] = nil }

    shared_examples "login redirector" do
      it "redirects to login path"
      it "adds flash message #{I18n.t('please_log_in')}"
    end

    context "get index" do
      before(:each) { get :index }

      it_should_behave_like "login redirector"
    end

    context "get dreams" do
      before(:each) { get :dreams }

      it_should_behave_like "login redirector"
    end
  end

  context "logged in user" do
    let(:user) { create(:user) }
    before(:each) { session[:user_id] = user.id }

    context "get index" do
      before(:each) { get :index }

      it "renders my/index"
    end

    context "get dreams" do
      before(:each) { get :dreams }

      it "renders my/dreams"
      it "adds public user dreams to @dreams"
      it "adds protected user dreams to @dreams"
      it "adds private user dreams to @dreams"
      it "doesn't add anonymous dreams to @dreams"
      it "doesn't add others protected dreams to @dreams"
      it "doesn't add others private dreams to @dreams"
    end
  end
end