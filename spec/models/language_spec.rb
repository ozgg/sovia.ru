require 'rails_helper'

RSpec.describe Language, type: :model do
  describe 'creation' do
    context 'with valid attributes' do
      it 'should be valid' do
        language = FactoryGirl.build :russian_language
        expect(language).to be_valid
      end
    end
  end
end
