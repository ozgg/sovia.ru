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
    let(:dream) { create(:dream) }

    it "returns empty string when entry has no tags" do
      expect(dream.tags_string).to eq('')
    end

    it "returns comma-separated tag names when entry has tags" do
      create(:dream_tag, name: 'второй символ')
      create(:dream_tag, name: 'Первый символ')
      dream.tags = Tag::Dream.last(2)
      expect(dream.tags_string).to eq('Первый символ, второй символ')
    end
  end

  context "#random_dream" do
    it "selects random public dream" do
      create(:article)
      create(:thought)
      create(:dream)
      create(:owned_dream)
      create(:protected_dream)
      create(:private_dream)

      dream = Entry::Dream.random_dream
      expect(dream.privacy).to eq(Entry::PRIVACY_NONE)
    end
  end

  context "when destroyed" do
    it "decrements entries_count for used tags" do
      tag   = create(:dream_tag)
      dream = create(:dream)
      dream.tags << tag
      expect { dream.destroy }.to change(tag, :entries_count).by(-1)
    end

    it "decrements entries_count for user" do
      user  = create(:user)
      dream = create(:dream, user: user)
      expect { dream.destroy }.to change(user, :entries_count).by(-1)
    end
  end
end
