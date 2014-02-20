require 'spec_helper'

describe Tag do
  let(:tag) { build(:tag, name: 'Нечто Интересное!') }

  it "is valid with valid attributes" do
    pending
    expect(tag).to be_valid
  end

  it "is invalid without name" do
    pending
    tag.name = ' '
    expect(tag).not_to be_valid
  end

  it "strips excessive spaces from name" do
    pending
    tag.name = " foo \t\r\n bar "
    tag.valid?
    expect(tag.name).to eq('foo bar')
  end

  it "creates canonical form before validating" do
    pending
    tag.valid?
    expect(tag.canonical_name).to eq('нечтоинтересное')
  end

  it "leaves canonical name equal to stripped name for empty canonization" do
    pending
    tag.name = '???   '
    tag.valid?
    expect(tag.canonical_name).to eq('???')
  end

  it "has unique canonical form" do
    pending
    tag.save
    another_tag = build(:tag, name: 'нечто интересное')
    expect(another_tag).not_to be_valid
  end

  it "uses canonical form for search" do
    pending
    tag.save
    expect(Tag.match_by_name('нечто интересное', tag.type)).to eq(tag)
  end

  it "creates letter based on first name character" do
    pending
    tag.valid?
    expect(tag.letter).to eq('Н')
  end
end
