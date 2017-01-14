require 'rails_helper'

RSpec.describe SearchQuery, type: :model do
  subject { build :search_query }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'

  describe 'before validation' do
    it 'trims body' do
      subject.body = 'a' * 256
      subject.valid?
      expect(subject.body.length).to eq(255)
    end
  end
end
