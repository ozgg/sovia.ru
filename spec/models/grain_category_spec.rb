require 'rails_helper'

RSpec.describe GrainCategory, type: :model do
  subject { build :grain_category }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_unique_name'
  it_behaves_like 'required_name'
end
