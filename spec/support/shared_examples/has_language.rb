require 'rails_helper'

shared_examples_for 'has_language' do
  let(:model) { described_class.to_s.underscore.to_sym }

  it 'is invalid without language' do
    entity = build model, language: nil
    expect(entity).not_to be_valid
  end
end
