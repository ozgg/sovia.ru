require 'rails_helper'

RSpec.shared_examples_for 'record_not_found_exception' do
  it 'raises ActiveRecord::RecordNotFound' do
    expect(action).to raise_error(ActiveRecord::RecordNotFound)
  end
end
