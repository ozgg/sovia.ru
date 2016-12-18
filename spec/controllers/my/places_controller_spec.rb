require 'rails_helper'

RSpec.describe My::PlacesController, type: :controller do
  let(:user) { create :user }
  let(:entity) { create :place, user: user }

  before :each do
    allow(subject).to receive(:current_user).and_return(user)
    allow(subject).to receive(:restrict_anonymous_access)
    allow(entity.class).to receive(:find_by).and_return(entity)
  end

  it_behaves_like 'list_for_owner'
  it_behaves_like 'entity_for_owner'

  describe 'get dreams' do
    pending
  end
end
