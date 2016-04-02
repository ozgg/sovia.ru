require 'rails_helper'

RSpec.shared_examples_for 'required_user' do
  let(:model) { described_class.to_s.underscore.to_sym }

  it 'is invalid without user' do
    entity = build model, user: nil
    expect(entity).not_to be_valid
  end
end
