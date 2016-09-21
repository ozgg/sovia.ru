require 'rails_helper'

RSpec.shared_examples_for 'page_for_interpreters' do
  it 'requires interpreter roles' do
    expect(subject).to have_received(:require_role).with(:chief_interpreter, :interpreter)
  end
end
