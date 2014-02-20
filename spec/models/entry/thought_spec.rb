require 'spec_helper'

describe Entry::Thought do
  let(:thought) { build(:thought) }

  context "when validating" do
    it "is valid with valid attributes" do
      expect(thought).to be_valid
    end

    it "is invalid without user" do
      thought.user = nil
      expect(thought).not_to be_valid
    end
  end

  context "when destroyed" do
    it "decrements entries_count for used tags" do
      tag  = create(:thought_tag)
      thought = create(:thought)
      thought.tags << tag
      expect { thought.destroy }.to change(tag, :entries_count).by(-1)
    end

    it "decrements entries_count for user" do
      user = create(:user)
      thought = create(:thought, user: user)
      expect { thought.destroy }.to change(user, :entries_count).by(-1)
    end
  end
end
