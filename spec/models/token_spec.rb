require 'rails_helper'

RSpec.describe Token, type: :model do
  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'
  it_behaves_like 'has_trace'
end
