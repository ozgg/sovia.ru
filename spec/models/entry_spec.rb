require 'spec_helper'

describe Entry do
  context "new entry" do
    let(:entry) { Entry.new }

    it "is invalid with empty body" do
      pending
      entry.body = ' '
      entry.valid?
      expect(entry.errors).to have_key(:body)
    end

    it "is invalid without allowed privacy" do
      pending
      entry.privacy = 42
      entry.valid?
      expect(entry.errors).to have_key(:privacy)
    end
  end

  context "#editable_by?" do
    let(:owner) { create(:user) }
    let(:entry) { build(:owned_entry, user: owner) }

    it "is editable by owner" do
      pending
      expect(entry).to be_editable_by(owner)
    end

    it "is editable by other user with moderator role" do
      pending
      moderator = create(:moderator)
      expect(entry).to be_editable_by(moderator)
    end

    it "is not editable by other user without moderator role" do
      pending
      user = create(:user)
      expect(entry).not_to be_editable_by(user)
    end

    it "is not editable by anonymous user" do
      pending
      expect(entry).not_to be_editable_by(nil)
    end
  end

  context "#visible_to?" do
    let(:user) { create(:user) }
    let(:owner) { create(:user) }
    
    shared_examples "visible to user" do
      it "is visible to user" do
        pending
        expect(entry).to be_visible_to(user)
      end
    end

    shared_examples "visible to owner" do
      it "is visible to owner" do
        pending
        expect(entry).to be_visible_to(owner)
      end
    end

    shared_examples "not visible to anonymous" do
      it "is not visible to anonymous" do
        pending
        expect(entry).not_to be_visible_to(nil)
      end
    end

    context "when privacy is 'none'" do
      let(:entry) { build(:owned_entry, user: owner) }

      it "is visible to anonymous user" do
        pending
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
        pending
        expect(entry).not_to be_visible_to(user)
      end

      it_should_behave_like "not visible to anonymous"
      it_should_behave_like "visible to owner"
    end
  end

  context "#tags_string=" do
    #let!(:existing_tag) { create(:tag, name: 'Раз') }
    let(:entry) { create(:entry, entry_type: Entry::TYPE_DREAM) }

    it "adds new tags to entry_tags" do
      pending
      expect { entry.tags_string = 'Слово, Дело'}.to change(Tag, :count).by(2)
    end

    it "doesn't add existing tag to entry_tags" do
      pending
      expect { entry.tags_string = 'Раз'}.not_to change(Tag, :count)
    end

    it "adds tags to entry" do
      pending
      entry.tags_string = 'раз'
      expect(entry.tags).to include(existing_tag)
    end

    it "ignores repeated tags" do
      pending
      entry.tags_string = 'люди, Люди, ЛЮДИ, люди, лЮди'
      expect(entry.tags.length).to eq(1)
    end

    it "ignores empty tags" do
      pending
      entry.tags_string = ', ,,   раз,    ,'
      expect(entry.tags.length).to eq(1)
    end

    it "destroys link for absent tags" do
      pending
      entry.tags << existing_tag
      entry.tags_string = 'Другое, прочее'
      expect(entry.tags).not_to include(existing_tag)
    end

    it "changes dreams_count for tag when it is deleted" do
      pending
      entry.tags << existing_tag
      expect { entry.tags_string = 'другое'}.to change(existing_tag, :dreams_count).by(-1)
    end
  end

  context "#tags_string" do
    let(:entry) { create(:entry, entry_type: Entry::TYPE_DREAM ) }

    it "returns empty string when entry has no tags" do
      pending
      expect(entry.tags_string).to eq('')
    end

    it "returns comma-separated tag names when entry has tags" do
      pending
      create(:tag, name: 'второй символ')
      create(:tag, name: 'Первый символ')
      entry.tags = Tag.last(2)
      expect(entry.tags_string).to eq('Первый символ, второй символ')
    end
  end

  context "when destroyed" do
    it "decrements dreams_count for used tags" do
      pending
      tag       = create(:tag)
      dream     = create(:entry, entry_type: Entry::TYPE_DREAM)
      dream.tags << tag
      expect { dream.destroy }.to change(tag, :dreams_count).by(-1)
    end
  end
end
