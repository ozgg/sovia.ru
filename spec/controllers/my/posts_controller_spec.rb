require 'rails_helper'

RSpec.describe My::PostsController, type: :controller do
  let(:user) { create :user }
  let(:entity) { create :post, user: user }

  it_behaves_like 'list_for_owner'
end
