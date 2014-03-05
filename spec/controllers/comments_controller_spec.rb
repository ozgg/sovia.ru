require 'spec_helper'

describe CommentsController do
  let(:entry) { create(:dream) }

  context "post create with valid parameters" do
    let(:comment_parameters) { { entry_id: entry.id, body: 'Oh, hi!' } }

    it "assigns a new Comment to @comment" do
      post :create, comment: comment_parameters
      expect(assigns[:comment]).to be_a(Comment)
    end

    it "adds comment to database" do
      expect { post :create, comment: comment_parameters}.to change(Comment, :count).by(1)
    end

    it "adds flash notice #{I18n.t('comment.created')}" do
      post :create, comment: comment_parameters
      expect(flash[:notice]).to eq(I18n.t('comment.created'))
    end

    it "redirects to entry path" do
      post :create, comment: comment_parameters
      expect(response).to redirect_to(entry)
    end
  end

  context "post create with invalid parameters" do
    let(:comment_parameters) { { entry_id: -1, body: '  ' } }

    it "assigns a new comment to @comment" do
      post :create, comment: comment_parameters
      expect(assigns[:comment]).to be_a(Comment)
    end

    it "leaves Comments table intact" do
      expect { post :create, comment: comment_parameters }.not_to change(Comment, :count)
    end

    it "renders comments/new" do
      post :create, comment: comment_parameters
      expect(response).to render_template('comments/new')
    end
  end

  context "post create for forbidden entry" do
    let(:entry) { create(:private_dream) }
    let(:post_parameters) { { comment: { entry_id: entry.id, body: 'A' } } }

    it "raises Forbidden error" do
      expect { post :create, post_parameters }.to raise_exception(ApplicationController::ForbiddenException)
    end
  end
end
