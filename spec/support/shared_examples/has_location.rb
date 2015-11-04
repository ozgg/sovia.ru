require 'rails_helper'

RSpec.shared_examples_for 'has_location' do
  let(:model) { described_class.to_s.underscore.to_sym }
  let(:entity) { build model }

  describe '#coordinates=' do
    it 'sets latitude and longitude' do
      entity.coordinates = [55.6, 36.8]
      expect(entity.latitude).to eq(55.6)
      expect(entity.longitude).to eq(36.8)
    end
  end

  describe 'normalizing coordinates before validation' do
    it 'sets latitude as nil if it is less than -90' do
      entity.coordinates = [-90.25, 0]
      entity.valid?
      expect(entity.latitude).to be_nil
    end

    it 'sets latitude as nil if it is greater than 90' do
      entity.coordinates = [90.25, 0]
      entity.valid?
      expect(entity.latitude).to be_nil
    end

    it 'leaves latitude intact if coordinates are valid' do
      entity.coordinates = [55.5, 0]
      entity.valid?
      expect(entity.latitude).to eq(55.5)
    end

    it 'sets latitude as nil if longitude is nil' do
      entity.longitude = nil
      entity.valid?
      expect(entity.latitude).to be_nil
    end

    it 'sets longitude as nil if it is less than -180' do
      entity.coordinates = [0, -180.25]
      entity.valid?
      expect(entity.longitude).to be_nil
    end

    it 'sets longitude as nil if it is greater than 180' do
      entity.coordinates = [0, 180.25]
      entity.valid?
      expect(entity.longitude).to be_nil
    end

    it 'leaves longitude intact if coordinates are valid' do
      entity.coordinates = [55.5, 37.75]
      entity.valid?
      expect(entity.longitude).to eq(37.75)
    end

    it 'sets longitude as nil if latitude is nil' do
      entity.latitude = nil
      entity.longitude = 37.75
      entity.valid?
      expect(entity.longitude).to be_nil
    end
  end
end
