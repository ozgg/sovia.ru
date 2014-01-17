require 'spec_helper'

describe TagsController do
  let!(:entry_tag) { create(:entry_tag) }

  shared_examples "restricted area" do
    it "redirects to root page"
    it "adds flash message 'Не хватает прав'"
  end

  shared_examples "restricted tags management" do
    context "get index" do
      before(:each) { get :index }

      it_should_behave_like "restricted area"
    end

    context "get show" do
      before(:each) { get :show, id: entry_tag }

      it_should_behave_like "restricted area"
    end

    context "get edit" do
      before(:each) { get :edit, id: entry_tag }

      it_should_behave_like "restricted area"
    end

    context "get new" do
      before(:each) { get :new }

      it_should_behave_like "restricted area"
    end

    context "post create" do
      before(:each) { post :create, entry_tag: { name: 'Ещё что-то интересное' } }

      it_should_behave_like "restricted area"
    end

    context "patch update" do
      before(:each) { patch :update, id: entry_tag, entry_tag: { name: 'Прдунь' } }

      it_should_behave_like "restricted area"
    end

    context "delete destroy" do
      before(:each) { delete :destroy, id: entry_tag }

      it_should_behave_like "restricted area"
    end
  end

  context "anonymous user" do
    before(:each) { session[:user_id] = nil }

    it_should_behave_like "restricted tags management"
  end

  context "unauthorized user" do
    before(:each) { session[:user_id] = create(:user).id }

    it_should_behave_like "restricted tags management"
  end

  context "editor" do
    before(:each) { session[:user_id] = create(:editor).id }

    context "get index" do
      before(:each) { get :index }

      it "assigns tags to @tags"
      it "renders tags/index"
    end

    context "get show" do
      before(:each) { get :show, id: entry_tag }

      it "assigns tag to @tag"
      it "renders tags/show"
    end

    context "get new" do
      before(:each) { get :new }

      it "assigns new tag to @tag"
      it "renders tags/new"
    end

    context "post create with valid attributes" do
      let(:action) { lambda { post :create, entry_tag: { name: 'Интересное' } } }

      it "assigns new tag to @tag"
      it "creates tag in database"
      it "redirects to tag page"
      it "adds flash message 'Метка добавлена'"
    end

    context "post create with invalid attributes" do
      let(:action) { lambda { post :create, entry_tag: { name: ' ' } } }

      it "assigns new tag to @tag"
      it "doesn't create tag in database"
      it "renders tags/new"
    end

    context "get edit" do
      before(:each) { get :edit, id: entry_tag }

      it "assigns tag to @tag"
      it "renders tags/edit"
    end

    context "patch update with valid parameters" do
      let(:action) { lambda { patch :update, id: entry_tag, entry_tag: { name: 'Прдунь' } } }

      it "assigns tag to @tag"
      it "updates tag"
      it "redirects to tag page"
      it "adds flash message 'Метка обновлена'"
    end

    context "patch update with invalid parameters" do
      let(:action) { lambda { patch :update, id: entry_tag, entry_tag: { name: ' ' } } }

      it "assigns tag to @tag"
      it "leaves tag intact"
      it "renders tags/edit"
    end

    context "delete destroy" do
      let(:action) { lambda { delete :destroy, id: entry_tag } }

      it "removes tag from database"
      it "redirects to tags index"
      it "adds flash message 'Метка удалена'"
    end
  end
end