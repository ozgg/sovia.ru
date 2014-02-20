require 'spec_helper'

describe Tag do
  let(:tag) { build(:tag, name: 'Нечто Интересное!') }

  it "is invalid without name" do
    tag.name = ' '
    tag.valid?
    expect(tag.errors).to have_key(:name)
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

  it "creates letter based on first name character" do
    tag.valid?
    expect(tag.letter).to eq('Н')
  end
end
