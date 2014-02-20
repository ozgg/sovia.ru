require 'spec_helper'

describe Tag::Dream do
  let!(:tag) { create(:dream_tag, name: 'Нечто Интересное!') }

  it "has unique canonical form" do
    another_tag = build(:dream_tag, name: 'нечто интересное')
    expect(another_tag).not_to be_valid
  end

  it "uses canonical form for search" do
    expect(Tag.match_by_name('нечто интересное')).to eq(tag)
  end
end