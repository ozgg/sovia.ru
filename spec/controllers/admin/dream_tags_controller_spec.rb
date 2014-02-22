require 'spec_helper'

describe Admin::DreamTagsController do
  shared_examples "restricted area" do
    it "raises UnauthorizedException" do
      expect { get :index }.to raise_error(ApplicationController::UnauthorizedException)
    end
  end

  context "when user is not logged in" do
    before(:each) { session[:user_id] = nil }

    it_should_behave_like "restricted area"
  end

  context "when user has no editor role" do
    before(:each) { session[:user_id] = create(:user).id }

    it_should_behave_like "restricted area"
  end

  context "when user has editor role" do
    let!(:dream_tag) { create(:dream_tag, name: 'Эталон', description: 'standard') }

    before(:each) { session[:user_id] = create(:editor).id }

    shared_examples "tag assigner" do
      it "assigns dream tag to @tag" do
        expect(assigns[:tag]).to be_a(Tag::Dream)
      end
    end

    shared_examples "new tag page renderer" do
      it "renders admin/dream_tags/new" do
        expect(response).to render_template('admin/dream_tags/new')
      end
    end

    shared_examples "edit tag page renderer" do
      it "renders admin/dream_tags/edit" do
        expect(response).to render_template('admin/dream_tags/edit')
      end
    end

    context "get index" do
      before(:each) { get :index }

      it "assigns tags list to @tags" do
        expect(assigns[:dream_tags]).to include(dream_tag)
      end

      it "renders admin/dream_tags/index" do
        expect(response).to render_template('admin/dream_tags/index')
      end
    end

    context "get new" do
      before(:each) { get :new }

      it_should_behave_like "new tag page renderer"

      it "assigns a new Tag::Dream to @tag" do
        expect(assigns[:tag]).to be_a_new(Tag::Dream)
      end
    end

    context "post create with invalid parameters" do
      before(:each) { post :create, dream_tag: { name: ' ' } }

      it_should_behave_like "tag assigner"
      it_should_behave_like "new tag page renderer"

      it "doesn't persist assigned tag" do
        expect(assigns[:tag]).not_to be_persisted
      end
    end

    context "post create with valid parameters" do
      before(:each) { post :create, dream_tag: { name: 'Создание' } }

      it_should_behave_like "tag assigner"

      it "persists assigned tag" do
        expect(assigns[:tag]).to be_persisted
      end

      it "adds flash notice #{I18n.t('tag.created')}" do
        expect(flash[:notice]).to eq(I18n.t('tag.created'))
      end

      it "redirects to created tag path" do
        expect(response).to redirect_to(admin_dream_tag_path(assigns[:tag]))
      end
    end

    context "get edit" do
      before(:each) { get :edit, id: dream_tag }

      it_should_behave_like "tag assigner"
      it_should_behave_like "edit tag page renderer"
    end

    context "patch update with invalid arrtibutes" do
      before(:each) { patch :update, id: dream_tag, dream_tag: { name: ' ', description: ' ' } }

      it_should_behave_like "tag assigner"
      it_should_behave_like "edit tag page renderer"

      it "leaves tag intact" do
        dream_tag.reload
        expect(dream_tag.name).to eq('Эталон')
        expect(dream_tag.description).to eq('standard')
      end
    end

    context "patch update with valid attributes" do
      before(:each) { patch :update, id: dream_tag, dream_tag: { name: 'a', description: 'b' } }

      it_should_behave_like "tag assigner"

      it "updates tag" do
        dream_tag.reload
        expect(dream_tag.name).to eq('a')
        expect(dream_tag.description).to eq('b')
      end

      it "adds flash notice #{I18n.t('tag.updated')}" do
        expect(flash[:notice]).to eq(I18n.t('tag.updated'))
      end

      it "redirects to tag path" do
        expect(response).to redirect_to(admin_dream_tag_path(dream_tag))
      end
    end

    context "delete destroy" do
      let(:action) { -> { delete :destroy, id: dream_tag } }

      it "destroys tag" do
        expect(action).to change(Tag::Dream, :count).by(-1)
      end

      it "adds flash notice #{I18n.t('tag.deleted')}" do
        action.call
        expect(flash[:notice]).to eq(I18n.t('tag.deleted'))
      end

      it "redirects to tags list" do
        action.call
        expect(response).to redirect_to(admin_dream_tags_path)
      end
    end
  end
end
