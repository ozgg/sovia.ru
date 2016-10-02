require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build :question }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'
  it_behaves_like 'required_body'
end
