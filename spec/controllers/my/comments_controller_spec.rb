require 'rails_helper'

RSpec.describe My::CommentsController, type: :controller do
  let!(:user) { create :user }
  let!(:entity) { create :comment, user: user }

  it_behaves_like 'list_for_owner'
end
