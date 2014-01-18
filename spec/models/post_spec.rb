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

  context "#tags_string=" do
    let!(:existing_tag) { create(:entry_tag, name: 'Раз') }
    let(:post) { create(:post, entry_type: Post::TYPE_DREAM) }

    it "adds new tags to entry_tags" do
      expect { post.tags_string = 'Слово, Дело'}.to change(EntryTag, :count).by(2)
    end

    it "doesn't add existing tag to entry_tags" do
      expect { post.tags_string = 'Раз'}.not_to change(EntryTag, :count)
    end

    it "adds tags to post" do
      post.tags_string = 'раз'
      expect(post.entry_tags).to include(existing_tag)
    end

    it "ignores repeated tags" do
      post.tags_string = 'люди, Люди, ЛЮДИ, люди, лЮди'
      expect(post.entry_tags.length).to eq(1)
    end

    it "ignores empty tags" do
      post.tags_string = ', ,,   раз,    ,'
      expect(post.entry_tags.length).to eq(1)
    end

    it "destroys link for absent tags" do
      post.entry_tags << existing_tag
      post.tags_string = 'Другое, прочее'
      expect(post.entry_tags).not_to include(existing_tag)
    end

    it "changes dreams_count for tag when it is deleted" do
      post.entry_tags << existing_tag
      expect { post.tags_string = 'другое'}.to change(existing_tag, :dreams_count).by(-1)
    end
  end

  context "#tags_string" do
    let(:post) { create(:post, entry_type: Post::TYPE_DREAM ) }

    it "returns empty string when post has no tags" do
      expect(post.tags_string).to eq('')
    end

    it "returns comma-separated tag names when post has tags" do
      create(:entry_tag, name: 'второй символ')
      create(:entry_tag, name: 'Первый символ')
      post.entry_tags = EntryTag.last(2)
      expect(post.tags_string).to eq('Первый символ, второй символ')
    end
  end

  context "when destroyed" do
    it "decrements dreams_count for used tags" do
      entry_tag = create(:entry_tag)
      dream     = create(:post, entry_type: Post::TYPE_DREAM)
      dream.entry_tags << entry_tag
      expect { dream.destroy }.to change(entry_tag, :dreams_count).by(-1)
    end
  end
end
