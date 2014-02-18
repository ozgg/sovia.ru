require 'spec_helper'

describe EntryType do
  let(:entry_type) { build(:entry_type) }

  it "is valid with valid attributes" do
    expect(entry_type).to be_valid
  end

  it "is invalid without name" do
    entry_type.name = ' '
    expect(entry_type).not_to be_valid
  end

  it "is invalid with bad-formatted name" do
    entry_type.name = 'Abc123'
    expect(entry_type).not_to be_valid
  end

  it "has unique name" do
    entry_type.save
    another_type = build(:entry_type, name: entry_type.name)
    expect(another_type).not_to be_valid
  end
end
