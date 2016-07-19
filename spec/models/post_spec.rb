require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { build :post }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_user'
  it_behaves_like 'has_owner'
  it_behaves_like 'commentable_by_community'

  describe 'before validation' do
    it 'generates slug as transliterated title' do
      subject.title = '  Публикация в тестах!  '
      subject.valid?
      expect(subject.slug).to eq('publikaciya-v-testakh')
    end
  end

  describe 'validation' do
    it 'fails without title' do
      subject.title = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:title)
    end

    it 'fails with too long title' do
      subject.title = 'A' * 201
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:title)
    end

    it 'fails without lead' do
      subject.lead = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:lead)
    end

    it 'fails with too long lead' do
      subject.lead = 'A' * 501
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:lead)
    end

    it 'fails without body' do
      subject.body = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end
  end

  describe '::page_for_visitor' do
    let!(:visible_post) { create :post }
    let!(:invisible_post) { create :post, visible: false }
    let!(:deleted_post) { create :post, deleted: true }

    it 'includes visible posts' do
      expect(Post.page_for_visitors(1)).to include(visible_post)
    end

    it 'does not include invisible posts' do
      expect(Post.page_for_visitors(1)).not_to include(invisible_post)
    end

    it 'does not include deleted posts' do
      expect(Post.page_for_visitors(1)).not_to include(deleted_post)
    end
  end

  describe '#tags_string=' do
    let!(:existing_tag) { create :tag }

    before(:each) { subject.save }

    it 'adds new non-empty and non-repeating tags to post' do
      expect { subject.tags_string = 'a,,A,c,c,b,' }.to change(PostTag, :count).by(3)
    end

    it 'removes absent tags' do
      create :post_tag, post: subject, tag: existing_tag
      expect { subject.tags_string = '' }.to change(PostTag, :count).by(-1)
    end
  end

  describe '#cache_tags!' do
    before(:each) { subject.save }

    it 'sets sorted tags to tags_cache' do
      subject.tags_string = 'b, a'
      subject.cache_tags!
      expect(subject.tags_cache).to eq(%w(a b))
    end
  end
end
