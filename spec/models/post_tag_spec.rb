require 'rails_helper'

RSpec.describe PostTag, type: :model do
  subject { build :post_tag }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_post'

  describe 'validation' do
    it 'fails without tag' do
      subject.tag = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:tag)
    end

    it 'fails with non-unique pair' do
      create :post_tag, post: subject.post, tag: subject.tag
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:tag)
    end
  end
end
