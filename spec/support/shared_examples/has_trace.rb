require 'rails_helper'

shared_examples_for 'has_trace' do
  let(:model) { described_class }

  describe 'class definition' do
    it 'includes has_trace' do
      expect(model.included_modules).to include(HasTrace)
    end
  end
end
