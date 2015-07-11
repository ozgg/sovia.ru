require 'rails_helper'

RSpec.describe PostTag, type: :model do
  let(:post) { create :post }
  let(:tag) { create :tag }

  describe 'validation' do
    it 'fails without post' do
      pair = build :post_tag, post: nil
      expect(pair).not_to be_valid
    end

    it 'fails without tag' do
      pair = build :post_tag, tag: nil
      expect(pair).not_to be_valid
    end

    it 'fails with non-unique pair' do
      pair = create :post_tag
      expect(build :post_tag, post: pair.post, tag: pair.tag).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :post_tag).to be_valid
    end
  end

  describe 'after create' do
    it 'increments post count in tag' do
      expect { create :post_tag, post: post, tag: tag }.to change(tag, :post_count).by(1)
    end
  end

  describe 'after destroy' do
    it 'decrements post count in tag' do
      pair = create :post_tag, post: post, tag: tag
      expect { pair.destroy }.to change(tag, :post_count).by(-1)
    end
  end
end
