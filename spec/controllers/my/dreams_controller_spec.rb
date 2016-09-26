require 'rails_helper'

RSpec.describe My::DreamsController, type: :controller do
  let(:user) { create :user }
  let(:entity) { create :dream, user: user }

  it_behaves_like 'list_for_owner'
end
