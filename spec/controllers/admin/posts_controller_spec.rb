require 'rails_helper'

RSpec.describe Admin::PostsController, type: :controller do
  let!(:entity) { create :post }

  it_behaves_like 'list_for_editors'
end
