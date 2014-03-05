require 'spec_helper'

describe Comment do
  let(:comment) { build(:comment) }
  let(:user) { create(:user) }
  let(:dream) { create(:dream) }

  context "integrity" do
    it "has non-blank body" do
      comment.body = ' '
      comment.valid?
      expect(comment.errors).to have_key(:body)
    end

    it "is invalid without entry_id" do
      comment.valid?
      expect(comment.errors).to have_key(:entry)
    end
  end
end
