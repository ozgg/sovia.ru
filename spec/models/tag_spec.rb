require 'rails_helper'

RSpec.describe Tag, type: :model do
  it_behaves_like 'has_name_with_slug'
  it_behaves_like 'finds_by_name'
  it_behaves_like 'has_unique_slug'

  context 'validating' do
    it 'passes with valid attributes' do
      expect(build :tag).to be_valid
    end
  end
end