require 'spec_helper'

describe DreamsController do
  let(:user) { create(:user) }

  shared_examples "visible dream" do
    it "assigns dream to @dream"
    it "renders dreams/show"
  end

  shared_examples "any user" do
    context "get index" do
      it "assigns public dreams to @dreams"
      it "renders dreams/index view"
    end

    context "get show for public dream" do
      it_should_behave_like "visible dream"
    end
  end

  shared_examples "restricted access" do
    it "redirects to dreams main page"
    it "adds flash message 'Недостаточно прав'"
  end

  shared_examples "added new dream" do
    it "creates new dream in database"
    it "redirects to dream page"
    it "adds flash message 'Сон добален'"
  end

  shared_examples "failed dream creation" do
    it "doesn't create dream in database"
    it "assigns new dream to @dream"
    it "renders dreams/new"
  end

  context "anonymous user" do
    before(:each) { session[:user_id] = nil }

    it_should_behave_like "any user"

    context "get show for users-only dream" do
      it_should_behave_like "restricted access"
    end

    context "get show for private dream" do
      it_should_behave_like "restricted access"
    end

    context "get new" do
      it "assigns new dream to @dream"
      it "renders dreams/new"
    end

    context "post create with valid parameters" do
      it "adds new dream with anonymous owner"

      it_should_behave_like "added new dream"
    end

    context "post create with invalid parameters" do
      it_should_behave_like "failed dream creation"
    end

    context "get edit" do
      it_should_behave_like "restricted access"
    end

    context "patch update" do
      it_should_behave_like "restricted access"
    end

    context "delete destroy" do
      it_should_behave_like "restricted access"
    end
  end

  context "authorized user" do
    before(:each) { session[:user_id] = user.id }

    it_should_behave_like "any user"

    context "get index" do
      it "assigns also user-only dreams to @dreams"
    end

    context "get show for user-only dream" do
      it_should_behave_like "visible dream"
    end

    context "get show for own private dream" do
      it_should_behave_like "visible dream"
    end

    context "get show for others private dream" do
      it_should_behave_like "restricted access"
    end

    context "post create" do
      it "adds new dream with current user as owner"
      it "increments dreams_count for current user"

      it_should_behave_like "added new dream"
    end

    context "get edit for own dream" do
      it "assigns edited dream to @dream"
      it "renders dreams/edit"
    end

    context "get edit for others dream" do
      it_should_behave_like "restricted access"
    end

    context "patch update for own dream" do
      it "updates dream"
      it "adds flash message 'Сон изменён'"
      it "redirects to dream page"
    end

    context "patch update for others dream" do
      it_should_behave_like "restricted access"
    end

    context "delete destroy for own dream" do
      it "removes dream from database"
      it "decrements dreams_count for current user"
      it "redirects to all dreams page"
      it "adds flash message 'Сон удалён'"
    end

    context "delete destroy for others dream" do
      it_should_behave_like "restricted access"
    end
  end

  context "getting tagged dreams" do
    pending "describe tagged dreams"
  end
end