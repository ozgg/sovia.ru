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
    it "assigns a new comment to @comment"
    it "leaves Comments table intact"
    it "renders comments/new"
  end

  context "post create for forbidden entry" do
    let(:entry) { create(:private_dream) }

    it "raises Forbidden error"
  end
end
