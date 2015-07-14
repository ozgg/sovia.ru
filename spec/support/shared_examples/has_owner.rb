require 'rails_helper'

shared_examples_for 'has_owner' do
  let(:model) { described_class }

  describe 'class definition' do
    it 'includes has_owner' do
      expect(model.included_modules).to include(HasOwner)
    end
  end
end
