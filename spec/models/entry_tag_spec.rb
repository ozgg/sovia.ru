require 'spec_helper'

describe EntryTag do
  let(:entry_tag) { build(:entry_tag, name: 'Нечто Интересное!') }

  it "is valid with valid attributes" do
    expect(entry_tag).to be_valid
  end

  it "is invalid without name" do
    entry_tag.name = ' '
    expect(entry_tag).not_to be_valid
  end

  it "creates canonical form before validating" do
    entry_tag.valid?
    expect(entry_tag.canonical_name).to eq('нечтоинтересное')
  end

  it "leaves canonical name equal to stripped name for empty canonization" do
    entry_tag.name = '???   '
    entry_tag.valid?
    expect(entry_tag.canonical_name).to eq('???')
  end

  it "has unique canonical form" do
    entry_tag.save
    another_tag = build(:entry_tag, name: 'нечто интересное')
    expect(another_tag).not_to be_valid
  end

  it "uses canonical form for search" do
    entry_tag.save
    expect(EntryTag.match_by_name('нечто интересное')).to eq(entry_tag)
  end

  it "creates letter based on first name character" do
    entry_tag.valid?
    expect(entry_tag.letter).to eq('Н')
  end
end
