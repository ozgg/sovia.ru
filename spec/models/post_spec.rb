require 'rails_helper'

RSpec.describe Post, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'
  it_behaves_like 'has_trace'

  describe 'validateion' do
    it 'fails without title' do
      post = build :post, title: ' '
      expect(post).not_to be_valid
    end

    it 'fails without lead' do
      post = build :post, lead: ' '
      expect(post).not_to be_valid
    end

    it 'fails without body' do
      post = build :post, body: ' '
      expect(post).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(build :post).to be_valid
    end
  end

  describe '#tags_string=' do
    pending
  end

  describe '#cache_tags!' do
    pending
  end
end
