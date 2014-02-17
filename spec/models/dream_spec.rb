require 'spec_helper'

describe Dream do
  context "after initialization" do
    let(:dream) { Dream.new }

    it "sets type to dream" do
      pending
      expect(dream.entry_type).to eq(Dream::TYPE_DREAM)
    end
  end

  context "#random_dream" do
    it "selects random public dream" do
      pending
      3.times { create(:article) }
      create(:dream)
      3.times { create(:article) }
      create(:dream)
      3.times { create(:protected_dream) }
      create(:dream)
      3.times { create(:private_dream) }

      entry = Dream.random_dream
      expect(entry).to be_a(Dream)
      expect(entry.privacy).to eq(Dream::PRIVACY_NONE)
    end
  end
end
