require 'rails_helper'

RSpec.describe Browser, type: :model do
  let(:model) { :browser }

  describe 'validation' do
    it 'passes with valid attributes' do
      entity = build model
      expect(entity).to be_valid
    end

    it 'fails without name' do
      entity = build model, name: ' '
      expect(entity).not_to be_valid
    end

    it 'fails with non-unique name' do
      existing = create model
      entity   = build model, name: existing.name
      expect(entity).not_to be_valid
    end
  end
end
