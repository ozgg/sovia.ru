require 'spec_helper'

describe Deed, type: :model do
  let(:deed) { build(:deed) }

  it "is invalid without user" do
    deed.user = nil
    expect(deed).not_to be_valid
  end

  it "is invalid without name" do
    deed.name = ' '
    expect(deed).not_to be_valid
  end

  it "is valid with valid attributes" do
    expect(deed).to be_valid
  end
end
