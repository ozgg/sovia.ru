require 'rails_helper'

RSpec.shared_examples_for 'has_azimuth' do
  let(:model) { described_class.to_s.underscore.to_sym }

  it 'fails for azimuth greater than 359' do
    entity = build model, azimuth: 360
    expect(entity).not_to be_valid
  end

  it 'fails for azimuth less than 0' do
    entity = build model, azimuth: -1
    expect(entity).not_to be_valid
  end
end
