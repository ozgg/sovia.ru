require 'spec_helper'

describe Tag do
  let(:tag) { build(:tag, name: 'Нечто Интересное!') }

  it "is valid with valid attributes" do
    expect(tag).to be_valid
  end

  it "is invalid without name" do
    tag.name = ' '
    expect(tag).not_to be_valid
  end

  it "strips excessive spaces from name" do
    tag.name = " foo \t\r\n bar "
    tag.valid?
    expect(tag.name).to eq('foo bar')
  end

  it "creates canonical form before validating" do
    tag.valid?
    expect(tag.canonical_name).to eq('нечтоинтересное')
  end

  it "leaves canonical name equal to stripped name for empty canonization" do
    tag.name = '???   '
    tag.valid?
    expect(tag.canonical_name).to eq('???')
  end

  it "has unique canonical form" do
    tag.save
    another_tag = build(:tag, name: 'нечто интересное', entry_type: tag.entry_type)
    expect(another_tag).not_to be_valid
  end

  it "uses canonical form for search" do
    tag.save
    expect(Tag.match_by_name('нечто интересное', tag.entry_type)).to eq(tag)
  end

  it "creates letter based on first name character" do
    tag.valid?
    expect(tag.letter).to eq('Н')
  end
end
