require 'spec_helper'

describe Entry::Post do
  let(:post) { build(:post) }

  context "when validating" do
    it "is valid with valid attributes" do
      expect(post).to be_valid
    end

    it "is invalid without user" do
      post.user = nil
      expect(post).not_to be_valid
    end
  end

  context "when destroyed" do
    it "decrements entries_count for used tags" do
      tag  = create(:post_tag)
      post = create(:post)
      post.tags << tag
      expect { post.destroy }.to change(tag, :entries_count).by(-1)
    end
  end
end
