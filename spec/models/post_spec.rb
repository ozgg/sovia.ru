require 'spec_helper'

describe Post do
  context "new post" do
    let(:post) { Post.new }

    it "is invalid with empty body" do
      post.body = ' '
      post.valid?
      expect(post.errors).to have_key(:body)
    end

    it "is invalid without allowed privacy" do
      post.privacy = 42
      post.valid?
      expect(post.errors).to have_key(:privacy)
    end
  end

  context "#editable_by?" do
    let(:owner) { create(:user) }
    let(:post) { create(:owned_post, entry_type: Post::TYPE_DREAM, user: owner) }

    it "is editable by owner" do
      expect(post.editable_by?(owner)).to be_true
    end

    it "is editable by other user with moderator role" do
      moderator = create(:moderator)
      expect(post.editable_by?(moderator)).to be_true
    end

    it "is not editable by other user without moderator role" do
      editor = create(:user)
      expect(post.editable_by?(editor)).to be_false
    end

    it "is not editable by anonymous user" do
      expect(post.editable_by?(nil)).to be_false
    end
  end

  context "#seen_to?" do
    let(:user) { create(:user) }
    let(:owner) { create(:user) }

    context "when privacy is 'none'" do
      let(:post) { create(:owned_post, entry_type: Post::TYPE_DREAM, user: owner) }

      it "is seen to anonymous user" do
        expect(post.seen_to?(nil)).to be_true
      end

      it "is seen to another registered user" do
        expect(post.seen_to?(user)).to be_true
      end

      it "is seen to owner" do
        expect(post.seen_to?(owner)).to be_true
      end
    end

    context "when privacy is 'users'" do
      let(:post) { create(:protected_post, entry_type: Post::TYPE_DREAM, user: owner) }

      it "is not seen by anonymous user" do
        expect(post.seen_to?(nil)).to be_false
      end

      it "is seen by other registered user" do
        expect(post.seen_to?(user)).to be_true
      end

      it "is seen by owner" do
        expect(post.seen_to?(owner)).to be_true
      end
    end

    context "when privacy is 'owner'" do
      let(:post) { create(:private_post, entry_type: Post::TYPE_DREAM, user: owner) }

      it "is not seen by anonymous user" do
        expect(post.seen_to?(nil)).to be_false
      end

      it "is not seen by other registered user" do
        expect(post.seen_to?(user)).to be_false
      end

      it "is seen by owner" do
        expect(post.seen_to?(owner)).to be_true
      end
    end
  end
end
