require 'spec_helper'

describe Dream do
  let(:dream) { build(:dream) }

  it "is valid with valid attributes" do
    expect(dream).to be_valid
  end

  it "is invalid without body" do
    dream.body = ' '
    expect(dream).not_to be_valid
  end

  it "is invalid without allowed privacy" do
    dream.privacy = 42
    expect(dream).not_to be_valid
  end
end
