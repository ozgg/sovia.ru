require 'spec_helper'

describe PostsController do
  let!(:user) { create(:user) }
  let!(:entry) { create(:post, user: user) }

  shared_examples "visible posts" do
    context "get index" do
      before(:each) { get :index }

      it "assigns posts to @posts" do
        expect(assigns[:posts]).to include(entry)
      end

      it "renders posts/index"
    end

    context "get show" do
      it "assigns post to @post"
      it "renders posts/show"
    end
  end

  shared_examples "restricted area" do
    it "redirects to posts page"
    it "adds flash message #{I18n.t('roles.insufficient_rights')}"
  end

  shared_examples "editable post" do
    context "get edit" do
      it "assigns post to @post"
      it "renders posts/edit"
    end

    context "patch update with valid parameters" do
      it "assigns post to @post"
      it "updates post data"
      it "redirects to post page"
      it "adds flash message #{I18n.t('post.updated')}"
    end

    context "patch update with invalid parameters" do
      it "assigns post to @post"
      it "leaves post intact"
      it "renders posts/edit"
    end

    context "delete destroy" do
      it "assigns post to @post"
      it "destroys post"
      it "redirects to posts path"
      it "adds flash message #{I18n.t('post.deleted')}"
    end
  end

  context "for anonymous user" do
    before(:each) { session[:user_id] = nil }

    it "refuses to show new post form"
    it "refuses to show update post form"
    it "refuses to update posts"
    it "refuses to delete posts"

    it_should_behave_like "visible posts"
  end

  context "for registered user" do
    before(:each) { session[:user_id] = user.id }

    context "get new" do
      it "assigns new post to @post"
      it "renders posts/new"
    end

    context "post create with valid parameters" do
      it "assigns post to @post"
      it "creates post in database"
      it "redirects to post path"
      it "adds flash message #{I18n.t('post.added')}"
    end

    context "post create with invalid parameters" do
      it "assigns post to @post"
      it "doesn't create post in database"
      it "renders posts/new"
    end

    context "get edit for others post" do
      it_should_behave_like "restricted area"
    end

    context "patch update for others post" do
      it_should_behave_like "restricted area"
    end

    context "delete destroy for others post" do
      it_should_behave_like "restricted area"
    end

    it_should_behave_like "visible posts"
    it_should_behave_like "editable post"
  end

  context "for moderator" do
    before(:each) { session[:user_id] = create(:moderator).id }

    it_should_behave_like "editable post"
  end
end