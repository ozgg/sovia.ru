require 'rails_helper'

RSpec.describe Post, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'
  it_behaves_like 'has_trace'
  it_behaves_like 'commentable_by_community'

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
    let!(:post) { create :post }
    let!(:existing_tag) { create :tag, language: post.language }

    it 'adds new non-empty and non-repeating tags to post' do
      expect { post.tags_string = 'a,,A,c,c,b,' }.to change(PostTag, :count).by(3)
    end

    it 'removes absent tags' do
      create :post_tag, post: post, tag: existing_tag
      expect { post.tags_string = ''}.to change(PostTag, :count).by(-1)
    end
  end

  describe '#cache_tags!' do
    it 'sets sorted tags to tags_cache' do
      post = create :post
      post.tags_string = 'b, a'
      post.cache_tags!
      expect(post.tags_cache).to eq(%w(a b))
    end
  end
end
