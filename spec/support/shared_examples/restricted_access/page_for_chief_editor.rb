require 'rails_helper'

RSpec.shared_examples_for 'page_for_chief_editor' do
  it 'requires role chief_editor' do
    expect(subject).to have_received(:require_role).with(:chief_editor)
  end
end
