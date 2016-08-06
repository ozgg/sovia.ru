require 'rails_helper'

RSpec.describe Figure, type: :model do
  subject { build :figure }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_post'

  describe 'validation' do
    it 'fails without slug' do
      subject.slug = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'fails with invalid slug' do
      subject.slug = '?'
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'fails with non-unique slug for post' do
      create :figure, post: subject.post, slug: subject.slug
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'fails without image' do
      subject.image = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:image)
    end
  end
end
