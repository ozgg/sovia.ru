require 'rails_helper'

RSpec.describe Pattern, type: :model do
  it_behaves_like 'has_language'
  it_behaves_like 'has_name_with_slug'
  it_behaves_like 'finds_by_name'
  it_behaves_like 'has_unique_slug'
  it_behaves_like 'has_owner'

  describe 'validation' do
    it 'passes with valid attributes' do
      expect(build :pattern).to be_valid
    end
  end
end
