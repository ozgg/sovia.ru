require 'spec_helper'

describe Dream do
  context "after initialization" do
    let(:dream) { Dream.new }

    it "sets type to dream" do
      expect(dream.entry_type).to eq(Dream::TYPE_DREAM)
    end
  end
end