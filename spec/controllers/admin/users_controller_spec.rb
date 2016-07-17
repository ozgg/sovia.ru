require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:entity) { create :user }

  it_behaves_like 'list_for_administration'
end
