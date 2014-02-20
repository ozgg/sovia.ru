require 'spec_helper'

describe Entry::Dream do
  context "#tags_string=" do
    let!(:existing_tag) { create(:dream_tag, name: 'Раз') }
    let(:dream) { create(:dream) }

    it "adds new tags to entry_tags" do
      expect { dream.tags_string = 'Слово, Дело' }.to change(Tag, :count).by(2)
    end

    it "doesn't add existing tag to entry_tags" do
      expect { dream.tags_string = 'Раз' }.not_to change(Tag, :count)
    end

    it "adds tags to entry" do
      dream.tags_string = 'раз'
      expect(dream.tags).to include(existing_tag)
    end

    it "ignores repeated tags" do
      dream.tags_string = 'люди, Люди, ЛЮДИ, люди, лЮди'
      expect(dream.tags.length).to eq(1)
    end

    it "ignores empty tags" do
      dream.tags_string = ', ,,   раз,    ,'
      expect(dream.tags.length).to eq(1)
    end

    it "destroys link for absent tags" do
      dream.tags << existing_tag
      dream.tags_string = 'Другое, прочее'
      expect(dream.tags).not_to include(existing_tag)
    end

    it "changes dreams_count for tag when it is deleted" do
      dream.tags << existing_tag
      expect { dream.tags_string = 'другое' }.to change(existing_tag, :entries_count).by(-1)
    end
  end

  context "#tags_string" do
    let(:entry) { create(:entry) }

    it "returns empty string when entry has no tags" do
      pending
      expect(entry.tags_string).to eq('')
    end

    it "returns comma-separated tag names when entry has tags" do
      pending
      create(:tag, name: 'второй символ', entry_type: entry.entry_type)
      create(:tag, name: 'Первый символ', entry_type: entry.entry_type)
      entry.tags = Tag.last(2)
      expect(entry.tags_string).to eq('Первый символ, второй символ')
    end
  end

  context "#random_dream" do
    it "selects random public dream" do
      pending
      entry_type = create(:entry_type_dream)
      create(:entry)
      create(:entry, entry_type: entry_type)
      create(:protected_entry, entry_type: create(:entry_type_article))
      create(:entry, entry_type: entry_type)
      create(:private_entry, entry_type: entry_type)

      entry = Entry.random_dream
      expect(entry).to be_dream
      expect(entry.privacy).to eq(Entry::PRIVACY_NONE)
    end
  end

  context "when destroyed" do
    it "decrements entries_count for used tags" do
      pending
      tag   = create(:tag)
      entry = create(:entry, entry_type: tag.entry_type)
      entry.tags << tag
      expect { entry.destroy }.to change(tag, :entries_count).by(-1)
    end

    it "decrements entries_count for user" do
      pending
      user  = create(:user)
      entry = create(:owned_entry, user: user)
      expect { entry.destroy }.to change(user, :entries_count).by(-1)
    end
  end

end