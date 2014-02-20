require 'spec_helper'

describe Entry do
  context "new entry" do
    let(:entry) { build(:entry) }

    it "is invalid with blank body" do
      entry.body = ' '
      entry.valid?
      expect(entry.errors).to have_key(:body)
    end

    it "is invalid without allowed privacy" do
      entry.privacy = 42
      entry.valid?
      expect(entry.errors).to have_key(:privacy)
    end
  end

  context "#editable_by?" do
    let(:owner) { create(:user) }
    let(:entry) { build(:owned_entry, user: owner) }

    it "is editable by owner" do
      expect(entry).to be_editable_by(owner)
    end

    it "is editable by other user with moderator role" do
      moderator = create(:moderator)
      expect(entry).to be_editable_by(moderator)
    end

    it "is not editable by other user without moderator role" do
      user = create(:user)
      expect(entry).not_to be_editable_by(user)
    end

    it "is not editable by anonymous user" do
      expect(entry).not_to be_editable_by(nil)
    end
  end

  context "#visible_to?" do
    let(:user) { create(:user) }
    let(:owner) { create(:user) }

    shared_examples "visible to user" do
      it "is visible to user" do
        expect(entry).to be_visible_to(user)
      end
    end

    shared_examples "visible to owner" do
      it "is visible to owner" do
        expect(entry).to be_visible_to(owner)
      end
    end

    shared_examples "not visible to anonymous" do
      it "is not visible to anonymous" do
        expect(entry).not_to be_visible_to(nil)
      end
    end

    context "when privacy is 'none'" do
      let(:entry) { build(:owned_entry, user: owner) }

      it "is visible to anonymous user" do
        expect(entry).to be_visible_to(nil)
      end

      it_should_behave_like "visible to user"
      it_should_behave_like "visible to owner"
    end

    context "when privacy is 'users'" do
      let(:entry) { build(:protected_entry, user: owner) }

      it_should_behave_like "not visible to anonymous"
      it_should_behave_like "visible to user"
      it_should_behave_like "visible to owner"
    end

    context "when privacy is 'owner'" do
      let(:entry) { build(:private_entry, user: owner) }

      it "is not visible to other registered user" do
        expect(entry).not_to be_visible_to(user)
      end

      it_should_behave_like "not visible to anonymous"
      it_should_behave_like "visible to owner"
    end
  end

  context "#recent_entries" do
    let!(:dream) { create(:dream) }
    let!(:article) { create(:article)}
    let!(:post) { create(:post)}
    let!(:thought) { create(:thought)}

    it "selects public article" do
      expect(Entry.recent_entries).to include(article)
    end

    it "selects public dream" do
      expect(Entry.recent_entries).to include(dream)
    end

    it "selects public post" do
      expect(Entry.recent_entries).to include(post)
    end

    it "selects public thought" do
      expect(Entry.recent_entries).to include(thought)
    end
  end
end
